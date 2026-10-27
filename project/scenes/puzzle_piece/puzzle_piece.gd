@tool
extends Node2D

class_name PuzzlePiece

enum Direction { Horizonal, Vertical }

@export var length = 10
@export var direction = Direction.Horizonal

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var array: PackedVector2Array = $Middle.polygon
	array[0].x = -(length / 2.0)
	array[1].x = (length / 2.0)
	array[2].x = (length / 2.0)
	array[3].x = -(length / 2.0)
	$Middle.polygon = array
	$Left.position.x = -7 - (length / 2.0)
	$Right.position.x = 7 + (length / 2.0)
	if direction == Direction.Horizonal:
		rotation_degrees = 0
	elif direction == Direction.Vertical:
		rotation_degrees = 90
