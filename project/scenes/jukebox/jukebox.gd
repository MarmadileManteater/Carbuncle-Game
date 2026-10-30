extends Node2D

var current_track: AudioStreamPlayer

func set_track(name: String) -> void:
	if current_track != null:
		if name == current_track.name:
			return
	var track: AudioStreamPlayer = find_child(name)
	var position = 0
	if current_track != null:
		current_track.stop()
		position = current_track.get_playback_position()
	track.play(position)
	current_track = track

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_phase_2_finished() -> void:
	$"Phase 3".play()

func _on_phase_3_finished() -> void:
	$"Phase 4".play()

func _on_phase_4_finished() -> void:
	$"Phase 5".play()

func _on_phase_5_finished() -> void:
	$"Phase 6".play()
