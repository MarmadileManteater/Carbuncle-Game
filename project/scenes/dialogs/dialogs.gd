extends Node2D

signal done
signal next_line

var dialogs: Array
var current: Dialog
var is_ready: bool = true
var is_started: bool = false
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogs = get_children()
	for dialog in dialogs:
		dialog.hide()
	
func advance() -> void:
	show()
	is_started = true
	if is_ready:
		if current != null:
			current.hide()
		if dialogs.size() == 0:
			done.emit()
			hide()
			is_started = false
			return
		next_line.emit(index)
		index += 1
		is_ready = false
		current = dialogs.pop_front()
		current.show()
		current.play()
		current.done.connect(
			func():
				is_ready = true
		, ConnectFlags.CONNECT_ONE_SHOT)

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				if is_started:
					advance()
