@tool
extends DefaultScene

@export var lamp_state: bool = false
var lamp_state_set = null

var is_lamp_timer_active = false
var lamp_count = 0
var monster_at_window = false
var has_opened = false
var window
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	window = $Clickable/Window
	if carbunkle_location == CarbunkleState.Location.BedroomWindow:
		$Monster.show()
		$Clickable.remove_child(window)
	if phase == 2:
		$Clickable.remove_child(window)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if lamp_state_set != lamp_state:
		var first_time = lamp_state_set == null
		lamp_state_set = lamp_state
		if is_lamp_timer_active:
			$LampTimer.stop()
			lamp_count += 1
			if lamp_count > 3 and not monster_at_window:
				lamp_count = 0
				$WindowSlam.play()
				$Monster.show()
				$Clickable.remove_child($Clickable/Window)
				phase_change.emit(2)
				monster_at_window = true
				carbunkle_move.emit(CarbunkleState.Location.BedroomWindow)
		if lamp_state:
			$Lamp.play("on")
			$LampShadeShadow.show()
			$LampLight.show()
			$WindowShadow.hide()
			$LampNoise.pitch_scale = 1
			if not first_time:
				$LampNoise.play()
				$LampTimer.start()
				is_lamp_timer_active = true
		else:
			$Lamp.play("off")
			$LampShadeShadow.hide()
			$LampLight.hide()
			$WindowShadow.show()
			$LampNoise.pitch_scale = 0.85
			if not first_time:
				$LampNoise.play()
				$LampTimer.start()
				is_lamp_timer_active = true

func clickable_clicked(node: VirtualClickable) -> void:
	super(node)
	if node.name == "Lamp":
		lamp_state = !lamp_state

func save_state() -> Dictionary:
	return {
		"lamp_state": lamp_state,
		"monster_at_window": monster_at_window,
		"has_opened": has_opened
	}

func load_state(state: Dictionary):
	lamp_state = state["lamp_state"]
	has_opened = state["has_opened"]

func _on_lamp_timer_timeout() -> void:
	is_lamp_timer_active = false
	lamp_count = 0

func capture() -> void:
	if not has_opened:
		has_opened = true
		$OpeningDialog.advance()
		disable_clickable()
		$OpeningDialog.done.connect(
			func ():
				enable_clickable()
		)
	
func update_carbunkle_location(location: CarbunkleState.Location) -> void:
	if location == CarbunkleState.Location.BedroomWindow:
		$Monster.show()
		$Clickable.remove_child(window)
	else:
		$Monster.hide()
		$Clickable.add_child(window)
		
		
func carbunkle_arrives(direction: DefaultScene.Direction):
	death.emit()
