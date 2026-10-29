@tool
extends StaticBody2D

class_name PuzzlePiece

signal click
signal unclick
signal hover
signal unhover

enum Direction { Horizonal, Vertical }

@export var length = 10
@export var direction = Direction.Horizonal
@export var collision_enabled = true
@export var click_enabled = true
@export var image_scale: Vector2 = Vector2(1, 1)
@export var image_position: Vector2 = Vector2(0, 0)

var click_start = null

func _ready() -> void:
	var shape = RectangleShape2D.new()
	shape.size = $CollisionShape2D.shape.size
	$CollisionShape2D.shape = shape

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Modifier.scale = image_scale
	$Modifier.position = image_position
	$CollisionShape2D.scale = image_scale
	var array: PackedVector2Array = $Modifier/Middle.polygon
	array[0].x = -(length / 2.0)
	array[1].x = (length / 2.0)
	array[2].x = (length / 2.0)
	array[3].x = -(length / 2.0)
	$Modifier/Middle.polygon = array
	$Modifier/Left.position.x = -7 - (length / 2.0) # magic number
	$Modifier/Right.position.x = 7 + (length / 2.0) # magic number
	if direction == Direction.Horizonal:
		rotation_degrees = 0
	elif direction == Direction.Vertical:
		rotation_degrees = 90
	
	$CollisionShape2D.shape.size.x = (42 - 10) + length
	$ClickPoint.size.x = $CollisionShape2D.shape.size.x
	$ClickPoint.position.x = -$CollisionShape2D.shape.size.x / 2.0
	if $CollisionShape2D.disabled != !collision_enabled:
		$CollisionShape2D.disabled = !collision_enabled


func _on_click_point_gui_input(event: InputEvent) -> void:
	if not click_enabled:
		return
	if event is InputEventMouseButton:
		if event.pressed:
			click.emit()
			click_start = event.global_position
		else:
			unclick.emit()
			click_start = null
	if click_start != null:
		if event is InputEventMouseMotion:
			var diff = click_start - event.global_position
			if direction == Direction.Horizonal:
				move_and_collide(Vector2(-diff.x, 0))
			if direction == Direction.Vertical:
				move_and_collide(Vector2(0, -diff.y))
			click_start = event.global_position

func _on_mouse_entered() -> void:
	hover.emit()
	
func _on_mouse_exited() -> void:
	unhover.emit()
