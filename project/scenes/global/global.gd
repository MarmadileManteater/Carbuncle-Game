extends Node

@export var starting_scene: String = "lock_puzzle"
var loaded_scene: DefaultScene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_scene(starting_scene)
	
func _input(event: InputEvent) -> void:
	$Cursor.input(event)

func unload_scene():
	remove_child(loaded_scene)
	loaded_scene.queue_free()
	loaded_scene = null

func load_scene(scene_name: String) -> void:
	if loaded_scene != null:
		unload_scene()
	
	loaded_scene = load("res://scenes/" + scene_name + "/" + scene_name + ".tscn").instantiate()
	loaded_scene.change_cursor.connect(
		func (cursor: VirtualCursor.Type):
			$Cursor.current_type = cursor
	)
	loaded_scene.lock_cursor_to_node.connect(
		func (node: Node2D):
			$Cursor.lock(node)
	)
	loaded_scene.unlock_cursor_from_node.connect(
		func ():
			$Cursor.unlock()
	)
	add_child(loaded_scene)
