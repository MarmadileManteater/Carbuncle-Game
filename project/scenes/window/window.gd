extends DefaultScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

func clickable_clicked(node: VirtualClickable) -> void:
	if node.name == "Back":
		change_scene.emit("room_with_window")
