extends DefaultScene

@export var carbunkle_visible = false
var was_visible = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if first_time:
		$AnimationPlayer.play("Approach")
		set_track_on_timeout("Phase 2", ($AnimationPlayer.current_animation_length / $AnimationPlayer.speed_scale) - 4)

func _process(delta: float) -> void:
	if carbunkle_visible and not was_visible:
		was_visible = true
		$CarbunkleWalkingBy.advance()
		disable_clickable()
		$CarbunkleWalkingBy.done.connect(
			func():
				enable_clickable()
		, ConnectFlags.CONNECT_ONE_SHOT)

func save_state() -> Dictionary:
	
	return {
		"animation": $AnimationPlayer.current_animation,
		"position": $AnimationPlayer.current_animation_position,
		"time_elapsed": time_elapsed,
		"is_playing": $AnimationPlayer.is_playing(),
		"was_visible": was_visible
	}

func load_state(state: Dictionary):
	if state["is_playing"]:
		$AnimationPlayer.play(state["animation"])
		$AnimationPlayer.seek(state["position"] + time_elapsed - state["time_elapsed"])
		was_visible = state["was_visible"]
