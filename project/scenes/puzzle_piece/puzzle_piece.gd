@tool
extends StaticBody2D

class_name PuzzlePiece

enum Direction { Horizonal, Vertical }

@export var length = 10
@export var direction = Direction.Horizonal

var click_start = null

func _ready() -> void:
	var shape = RectangleShape2D.new()
	shape.size = $CollisionShape2D.shape.size
	$CollisionShape2D.shape = shape

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var array: PackedVector2Array = $Middle.polygon
	array[0].x = -(length / 2.0)
	array[1].x = (length / 2.0)
	array[2].x = (length / 2.0)
	array[3].x = -(length / 2.0)
	$Middle.polygon = array
	$Left.position.x = -7 - (length / 2.0) # magic number
	$Right.position.x = 7 + (length / 2.0) # magic number
	if direction == Direction.Horizonal:
		rotation_degrees = 0
	elif direction == Direction.Vertical:
		rotation_degrees = 90
	
	$CollisionShape2D.shape.size.x = (42 - 10) + length
	$ClickPoint.size.x = $CollisionShape2D.shape.size.x
	$ClickPoint.position.x = -$CollisionShape2D.shape.size.x / 2.0


func _on_click_point_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			click_start = event.global_position
		else:
			click_start = null
	if click_start != null:
		if event is InputEventMouseMotion:
			var diff = click_start - event.global_position
			if direction == Direction.Horizonal:
				move_and_collide(Vector2(-diff.x, 0))
			if direction == Direction.Vertical:
				move_and_collide(Vector2(0, -diff.y))
			click_start = event.global_position
