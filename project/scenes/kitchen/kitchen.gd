extends DefaultScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if items["fridge_note"]:
		$FridgeNote.hide()
		$Clickable.remove_child($Clickable/FridgeNote)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _left_door_body_entered(body: Node2D) -> void:
	if body == $Monica:
		change_scene.emit("living_room")

func clickable_clicked(node: VirtualClickable) -> void:
	super(node)
	if node.name == "FridgeNote":
		$FridgeNote2.advance()
		$FridgeNote2.done.connect(
			func():
				item_obtained.emit("fridge_note")
				$FridgeNote.hide()
				enable_clickable()
				$Clickable.remove_child($Clickable/FridgeNote)
		)
		disable_clickable()

func save_state() -> Dictionary:
	return {
		"player_position": $Monica.position
	}

func load_state(state_info: Dictionary):
	$Monica.position = state_info["player_position"]
