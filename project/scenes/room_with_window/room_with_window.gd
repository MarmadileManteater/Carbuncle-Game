@tool
extends DefaultScene

@export var lamp_state: bool = false
var lamp_state_set = null

var is_lamp_timer_active = false
var lamp_count = 0
var monster_at_window = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if lamp_state_set != lamp_state:
		var first_time = lamp_state_set == null
		lamp_state_set = lamp_state
		if is_lamp_timer_active:
			$LampTimer.stop()
			lamp_count += 1
			if lamp_count > 3 and "window" in has_visited and not monster_at_window:
				lamp_count = 0
				$WindowSlam.play()
				$Monster.show()
				$Clickable.remove_child($Clickable/Window)
				set_track("Phase 2")
				monster_at_window = true
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
	if node.name == "Window":
		change_scene.emit("window")
	if node.name == "Lamp":
		lamp_state = !lamp_state

func save_state() -> Dictionary:
	return {
		"lamp_state": lamp_state,
		"monster_at_window": monster_at_window
	}

func load_state(state: Dictionary):
	lamp_state = state["lamp_state"]
	monster_at_window = state["monster_at_window"]
	if monster_at_window:
		$Monster.show()
		$Clickable.remove_child($Clickable/Window)
		set_track("Phase 2")

func _on_lamp_timer_timeout() -> void:
	is_lamp_timer_active = false
	lamp_count = 0

func capture() -> void:
	$OpeningDialog.advance()
	disable_clickable()
	$OpeningDialog.done.connect(
		func ():
			enable_clickable()
	)
