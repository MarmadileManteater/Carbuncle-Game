@tool
extends DefaultScene

@export var lamp_state: bool = false
var lamp_state_set = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if lamp_state_set != lamp_state:
		var first_time = lamp_state_set == null
		lamp_state_set = lamp_state
		if lamp_state:
			$Lamp.play("on")
			$LampShadeShadow.show()
			$LampLight.show()
			$WindowShadow.hide()
			$LampNoise.pitch_scale = 1
			$LampNoise.play()
		else:
			$Lamp.play("off")
			$LampShadeShadow.hide()
			$LampLight.hide()
			$WindowShadow.show()
			$LampNoise.pitch_scale = 0.85
			if not first_time:
				$LampNoise.play()

func clickable_clicked(node: VirtualClickable) -> void:
	if node.name == "Window":
		change_scene.emit("window")
	if node.name == "Lamp":
		lamp_state = !lamp_state
