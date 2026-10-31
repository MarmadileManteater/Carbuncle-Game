@tool
extends Node2D
class_name VirtualCursor

signal capture

enum Type { Back, Default, Grab, Notice, Point }
const types = ["back", "default", "grab", "notice", "point"]

var locked_node: Node2D = null

func get_type_as_string(type: Type) -> String:
	return types[type]

@export var current_type: Type = Type.Default
var set_type: Type = Type.Default

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if set_type != current_type:
		set_type = current_type
		var str = get_type_as_string(current_type)
		var new_location: Node2D = find_child(str)
		if new_location == null:
			$Sprite.position = Vector2(0, 0)
		else:
			$Sprite.position = new_location.position
		$Sprite.play(str)
	if locked_node != null:
		position = locked_node.position
		
func input(event: InputEvent):
	if event is InputEventKey:
		if event.keycode == 4194305 or event.keycode == 4194327:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		capture.emit()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		position = event.global_position

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if locked_node != null:
			if locked_node.has_method("move"):
				locked_node.move(event.relative)
		position += event.relative
		
func lock(node: Node2D):
	locked_node = node
	
func unlock():
	locked_node = null
