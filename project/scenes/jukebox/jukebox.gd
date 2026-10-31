extends Node2D

signal phase_change
var current_track: AudioStreamPlayer

func set_track(name: String) -> void:
	if current_track != null:
		if name == current_track.name:
			return
			
	for phase in find_children("Phase *"):
		phase.stop()
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
	phase_change.emit(3)

func _on_phase_3_finished() -> void:
	$"Phase 4".play()
	phase_change.emit(4)

func _on_phase_4_finished() -> void:
	$"Phase 5".play()
	phase_change.emit(5)

func _on_phase_5_finished() -> void:
	$"Phase 6".play()
	phase_change.emit(6)
