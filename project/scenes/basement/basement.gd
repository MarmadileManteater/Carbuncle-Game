extends DefaultScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Chaos.play()
	$Gun/AnimationPlayer.play("Fade")
	$Start.advance()
	$Start.next_line.connect(
		func (index):
			if index == 1:
				$Gun/AnimationPlayer.play_backwards("Fade")
				$Busted.play()
	)
	$Start.done.connect(
		func ():
			$End.advance()
	)
	$End.done.connect(
		func():
			$Chaos.stop()
			$Pump.play()
			$Pump.finished.connect(
				func():
					hide()
					$Shoot.play()
					$Shoot.finished.connect(
						func():
							change_scene.emit("fin")
					)
					
			)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
