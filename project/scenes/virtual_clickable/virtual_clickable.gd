@tool
extends Node2D
class_name VirtualClickable

signal click
signal unclick
signal hover
signal unhover

@export var cursor: VirtualCursor.Type = VirtualCursor.Type.Point
@export var size: Vector2 = Vector2.ZERO
var is_hovered: bool = false
var is_clicked: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var shape = RectangleShape2D.new()
	shape.size = size
	$Area2D/CollisionShape2D.shape = shape

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rect: RectangleShape2D = $Area2D/CollisionShape2D.shape
	if rect.size != size:
		rect.size = size

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent().name == "Cursor":
		is_hovered = true
		hover.emit()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.get_parent().name == "Cursor":
		is_hovered = false
		unhover.emit()
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				if is_hovered:
					is_clicked = true
					click.emit()
			else:
				if is_clicked:
					is_clicked = false
					unclick.emit()
			
