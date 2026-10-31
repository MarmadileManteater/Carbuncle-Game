extends DefaultScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(input: InputEvent) -> void:
	if input is InputEventMouseButton:
		if input.button_index == 1:
			get_tree().reload_current_scene()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
