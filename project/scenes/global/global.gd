extends Node

@export var starting_scene: String = "lock_puzzle"
var loaded_scene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_scene(starting_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func unload_scene():
	remove_child(loaded_scene)
	loaded_scene.queue_free()
	loaded_scene = null

func load_scene(scene_name: String) -> void:
	if loaded_scene != null:
		unload_scene()
	
	loaded_scene = load("res://scenes/" + scene_name + "/" + scene_name + ".tscn").instantiate()
	add_child(loaded_scene)
