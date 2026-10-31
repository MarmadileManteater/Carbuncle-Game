extends DefaultScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nest($LockPuzzle)
	$LockPuzzle.lock_completed.connect(
		func ():
			unlock_basement.emit()
	)
	super()
	$BasementLock.advance()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func carbunkle_arrives(direction: DefaultScene.Direction):
	death.emit()
