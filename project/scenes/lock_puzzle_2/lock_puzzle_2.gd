extends DefaultScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nest($LockPuzzle)
	super()
	$LockPuzzle.lock_completed.connect(
		func ():
			lock_kitchen.emit()
	)
	$BackdoorLock.advance()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
