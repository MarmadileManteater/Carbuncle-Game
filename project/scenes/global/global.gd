extends Node

@export var starting_scene: String = "lock_puzzle"
var loaded_scene: DefaultScene = null
var state: Dictionary = {}
var time_elapsed: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Jukebox.set_track("Phase 1")
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
	loaded_scene.change_scene.connect(
		func(new_scene_name: String):
			state[scene_name] = loaded_scene.save_state()
			load_scene(new_scene_name)
	)
	loaded_scene.on_timeout_trigger_track_change.connect(
		func(track_name: String, time: float):
			var timer = Timer.new()
			timer.one_shot = true
			timer.timeout.connect(
				func():
					remove_child(timer)
					timer.queue_free()
					$Jukebox.set_track(track_name)
			)
			add_child(timer)
			timer.start(time)
	)
	loaded_scene.trigger_track_change.connect(
		func(name: String):
			$Jukebox.set_track(name)
	)

	loaded_scene.time_elapsed = time_elapsed
	loaded_scene.first_time = not state.has(scene_name)
	if state.has(scene_name):
		loaded_scene.load_state(state[scene_name])
	loaded_scene.has_visited = state.keys()
	add_child(loaded_scene)


func _on_game_interval() -> void:
	time_elapsed += 0.1
	$RichTextLabel.text = "%f" % time_elapsed
	if loaded_scene != null:
		loaded_scene.time_elapsed = time_elapsed

func _on_cursor_capture() -> void:
	loaded_scene.capture()
