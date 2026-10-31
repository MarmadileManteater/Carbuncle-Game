extends Node

@export var starting_scene: String = "lock_puzzle"
var loaded_scene: DefaultScene = null
var loaded_scene_name: String
var state: Dictionary = {}
var time_elapsed: float = 0.0
var items: Dictionary = { "dph": false, "doorkey": false }
var is_kitchen_door_locked: bool = false
var searches: int = 0
var carbunkle_state: CarbunkleState = CarbunkleState.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Jukebox.set_track("Phase 1")
	load_scene(starting_scene)
	$CarbunkleTimer.timeout.connect(
		func():
			if carbunkle_state.phase > 1:
				knock()
	)
	$CarbunkleTimer.start()
	
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
					if track_name == "Phase 2":
						knock()
						carbunkle_state.location = CarbunkleState.Location.FrontDoor
						loaded_scene.update_carbunkle_location(carbunkle_state.location)
			)
			add_child(timer)
			timer.start(time)
	)
	loaded_scene.trigger_track_change.connect(
		func(name: String):
			$Jukebox.set_track(name)
	)
	loaded_scene.item_obtained.connect(
		func (item: String):
			searches+=1
			loaded_scene.searches = searches
			items[item] = true
			loaded_scene.items = items
			if item == "dph":
				loaded_scene.disable_clickable()
				$DPH.advance()
				$DPH.done.connect(
					func ():
						loaded_scene.enable_clickable()
				)
	)
	loaded_scene.phase_change.connect(
		func(phase: int):
			if phase >= carbunkle_state.phase:
				$Jukebox.set_track("Phase %d" % phase)
				carbunkle_state.phase = phase
	)
	loaded_scene.carbunkle_move.connect(
		func(location: CarbunkleState.Location):
			carbunkle_state.location = location
	)

	loaded_scene.time_elapsed = time_elapsed
	loaded_scene.first_time = not state.has(scene_name)
	if state.has(scene_name):
		loaded_scene.load_state(state[scene_name])
	loaded_scene.has_visited = state.keys()
	loaded_scene.came_from = loaded_scene_name
	loaded_scene_name = scene_name
	loaded_scene.items = items
	loaded_scene.searches = searches
	loaded_scene.carbunkle_location = carbunkle_state.location
	add_child(loaded_scene)


func _on_game_interval() -> void:
	time_elapsed += 0.1
	$RichTextLabel.text = "%f" % time_elapsed
	if loaded_scene != null:
		loaded_scene.time_elapsed = time_elapsed

func _on_cursor_capture() -> void:
	loaded_scene.capture()
	
func _process(delta: float) -> void:
	$Inventory/DPH.visible = items["dph"]
	$Inventory/Key.visible = items["doorkey"]

func knock() -> void:
	var distance = carbunkle_state.get_distance(loaded_scene_name)
	
	var sound = carbunkle_state.get_sound(is_kitchen_door_locked)
	
	var audio_level = 5
	
	if distance == 1:
		audio_level = 0
	if distance == 2:
		audio_level = -5
	
	$SoundMachine.play(sound, audio_level)
	if sound == SoundMachine.Sound.Busted || sound == SoundMachine.Sound.Opening:
		$Jukebox.set_track("Phase %d" % 6)
		carbunkle_state.phase = 6
			
