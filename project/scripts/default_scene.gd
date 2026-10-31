extends Node2D
class_name DefaultScene

signal change_scene
signal change_cursor
signal lock_cursor_to_node
signal unlock_cursor_from_node
signal on_timeout_trigger_track_change
signal trigger_track_change

var time_elapsed: float = 0.0
var first_time: bool = true
var has_visited: Array = []
var enable_clickable_zones: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var clickables = find_child("Clickable")
	if clickables != null:
		for clickable in clickables.get_children():
			if clickable is VirtualClickable:
				clickable.click.connect(
					func ():
						if enable_clickable_zones:
							clickable_clicked(clickable)
				)
				clickable.unclick.connect(
					func ():
						pass
				)
				clickable.hover.connect(
					func ():
						if enable_clickable_zones:
							cursor_change(clickable.cursor)
				)
				clickable.unhover.connect(
					func ():
						if enable_clickable_zones:
							cursor_change(VirtualCursor.Type.Default)
				)

func nest(scene: DefaultScene) -> void:
	scene.change_cursor.connect(cursor_change)
	scene.lock_cursor_to_node.connect(lock_cursor)
	scene.unlock_cursor_from_node.connect(unlock_cursor)
	
func cursor_change(cursor: VirtualCursor.Type) -> void:
	change_cursor.emit(cursor)

func lock_cursor(node: Node2D) -> void:
	lock_cursor_to_node.emit(node)
	
func unlock_cursor() -> void:
	unlock_cursor_from_node.emit()
	
func set_track_on_timeout(track_name: String, time: float) -> void:
	on_timeout_trigger_track_change.emit(track_name, time)
	
func set_track(name: String) -> void:
	trigger_track_change.emit(name)
	
func clickable_clicked(node: VirtualClickable) -> void:
	if node.scene != null and node.scene != "":
		change_scene.emit(node.scene)
	
func save_state() -> Dictionary:
	return {}
	
func load_state(state_info: Dictionary) -> void:
	pass
	
func disable_clickable() -> void:
	enable_clickable_zones = false
	cursor_change(VirtualCursor.Type.Default)

func enable_clickable() -> void:
	var timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(
		func():
			enable_clickable_zones = true
			remove_child(timer)
			timer.queue_free()
	, ConnectFlags.CONNECT_ONE_SHOT)
	add_child(timer)
	timer.start(0.5)
func capture() -> void:
	pass
