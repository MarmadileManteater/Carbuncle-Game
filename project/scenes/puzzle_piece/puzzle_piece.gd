@tool
extends StaticBody2D

class_name PuzzlePiece

const SLIDE_NOISE_THRESHOLD = 6

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

var is_hovered = false
var is_clicked = false
var is_last_movement_positive = null

func _ready() -> void:
	var shape = RectangleShape2D.new()
	shape.size = $CollisionShape2D.shape.size
	$CollisionShape2D.shape = shape
	$Area2D/CollisionShape2D.shape = shape

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
	
	$SlideNoise.pitch_scale = 1.0 - ((length - 435.0) / 1200)

func move(motion: Vector2):
	var movement: Vector2
	if direction == Direction.Horizonal:
		movement = Vector2(motion.x, 0)
	if direction == Direction.Vertical:
		movement = Vector2(0, motion.y)
	var is_positive = movement >= Vector2.ZERO
	if movement.distance_to(Vector2.ZERO) > SLIDE_NOISE_THRESHOLD:
		if is_positive != is_last_movement_positive:
			is_last_movement_positive = is_positive
			if not $SlideNoise.playing:
				$SlideNoise.play()
	move_and_collide(movement)

func _input(event: InputEvent):
		if event is InputEventMouseButton:
			if event.pressed:
				if is_hovered:
					click.emit()
					is_clicked = true
			else:
				unclick.emit()
				is_clicked = false
				is_hovered = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not is_clicked:
		hover.emit()
		is_hovered = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if not is_clicked:
		unhover.emit()
		is_hovered = false
