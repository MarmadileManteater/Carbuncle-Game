extends Node

@export var starting_scene: String = "lock_puzzle"
var loaded_scene: DefaultScene = null
var locked_node: Node2D = null
var locked_node_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	load_scene(starting_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if locked_node != null:
		$Cursor.position = locked_node.global_position
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if locked_node == null:
			if locked_node_pos == null:
				$Cursor.position = event.global_position 
				if $Cursor.animation == "default" or $Cursor.animation == "notice":
					$Cursor.position += Vector2(42, 42)
				if $Cursor.animation == "point":
					$Cursor.position += Vector2(0, 42)
			else:
				Input.warp_mouse(locked_node_pos)
				locked_node_pos = null

func unload_scene():
	remove_child(loaded_scene)
	loaded_scene.queue_free()
	loaded_scene = null

func load_scene(scene_name: String) -> void:
	if loaded_scene != null:
		unload_scene()
	
	loaded_scene = load("res://scenes/" + scene_name + "/" + scene_name + ".tscn").instantiate()
	loaded_scene.change_cursor.connect(
		func (cursor_name: String):
			if locked_node == null:
				$Cursor.play(cursor_name)
	)
	loaded_scene.lock_cursor_to_node.connect(
		func (node: Node2D):
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
			locked_node = node
	)
	loaded_scene.unlock_cursor_from_node.connect(
		func ():
			if locked_node != null:
				$Cursor.position += Vector2(42, 42)
				var pos = locked_node.global_position
				locked_node = null
				Input.warp_mouse(pos)
				locked_node_pos = pos
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	)
	add_child(loaded_scene)
