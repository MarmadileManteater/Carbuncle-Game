@tool
extends Node2D

@export var width = 10
var default_bar_coords = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_bar_coords[0] = $Middle.polygon[0].x
	default_bar_coords[1] = $Middle.polygon[1].x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(default_bar_coords)
	#$Middle.polygon[0].x = -(width / 2.0)
	#$Middle.polygon[1].x = (width / 2.0)
	#$Middle.polygon[2].x = (width / 2.0)
	#$Middle.polygon[3].x = -(width / 2.0)
	print($Middle.polygon)
	print("needs update")
	#$Right.position.x = width
