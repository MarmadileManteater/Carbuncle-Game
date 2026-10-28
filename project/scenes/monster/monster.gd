@tool
extends AnimatedSprite2D

enum Form { Hidden, Revealed, Partially }

@export var form = Form.Hidden
var form_set: Form

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if form == Form.Revealed && form != form_set:
		$AnimationPlayer.play("visible")
		play("revealed")
		$mouth.show()
		$mouth.play()
		$"eye 1".show()
		$"eye 1".play()
		$"eye 2".show()
		$"eye 2".play()
		$cover.show()
		form_set = form
	if form == Form.Hidden && form != form_set:
		play("walk_2")
		$mouth.hide()
		$"eye 1".hide()
		$"eye 2".hide()
		$cover.hide()
		form_set = form
	if form == Form.Partially && form != form_set:
		play("walk_2")
		$mouth.show()
		$mouth.stop()
		$"eye 1".show()
		$"eye 1".stop()
		$"eye 2".show()
		$"eye 2".stop()
		$cover.show()
		$AnimationPlayer.play("partially")
		form_set = form
