extends Node2D
class_name DefaultScene

signal change_cursor
signal lock_cursor_to_node
signal unlock_cursor_from_node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func cursor_change(cursor: VirtualCursor.Type) -> void:
	change_cursor.emit(cursor)

func lock_cursor(node: Node2D) -> void:
	lock_cursor_to_node.emit(node)
	
func unlock_cursor() -> void:
	unlock_cursor_from_node.emit()
