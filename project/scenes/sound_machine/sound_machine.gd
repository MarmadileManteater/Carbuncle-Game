extends Node2D

class_name SoundMachine

enum Sound { Knocking, Banging, Jiggling, TryBreaking, WindowKnocking, Busted, Opening }


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play(sound: Sound, audio_level: float = 1) -> void:
	var player: AudioStreamPlayer
	if sound == Sound.Knocking:
		var knocking = [ $Knocking1, $Knocking2 ]
		player = knocking[randi_range(0,1)]
	if sound == Sound.Banging:
		player = $DoorBanging
	if sound == Sound.Jiggling:
		player = $DoorJigglingHandle
	if sound == Sound.TryBreaking:
		player = $DoorTryingToBreakIn
	if sound == Sound.Busted:
		player = $DoorBustedOpen
	if sound == Sound.WindowKnocking:
		player = $WindowKnocking
	if sound == Sound.Opening:
		player = $DoorOpening
	player.volume_linear = audio_level
	player.play()
