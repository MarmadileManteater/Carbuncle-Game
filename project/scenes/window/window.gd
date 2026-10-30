extends DefaultScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if first_time:
		$AnimationPlayer.play("Approach")

func clickable_clicked(node: VirtualClickable) -> void:
	if node.name == "Back":
		change_scene.emit("room_with_window")

func save_state() -> Dictionary:
	
	return {
		"animation": $AnimationPlayer.current_animation,
		"position": $AnimationPlayer.current_animation_position,
		"time_elapsed": time_elapsed,
		"is_playing": $AnimationPlayer.is_playing()
	}

func load_state(state: Dictionary):
	if state["is_playing"]:
		$AnimationPlayer.play(state["animation"])
		$AnimationPlayer.seek(state["position"] + time_elapsed - state["time_elapsed"])
