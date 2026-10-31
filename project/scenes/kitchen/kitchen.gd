@tool
extends DefaultScene

enum DoorState { Closed, Locked, Open }

@export var backdoor_state: DoorState = DoorState.Closed

@export var basement_state: DoorState = DoorState.Locked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if items["fridge_note"]:
		$FridgeNote.hide()
		$Clickable.remove_child($Clickable/FridgeNote)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if $Carbunkle.visible:
			$Carbunkle.position -= ($Carbunkle.position - $Monica.position).normalized()
	if basement_state == DoorState.Closed:
		$BasementLockUnlocked.show()
		$BasementLockLocked.hide()
		$BasementDoorClosed.show()
		$BasementDoorOpen.hide()
	if basement_state == DoorState.Locked:
		$BasementLockUnlocked.hide()
		$BasementLockLocked.show()
		$BasementDoorClosed.show()
		$BasementDoorOpen.hide()
	if basement_state == DoorState.Open:
		$BasementLockUnlocked.hide()
		$BasementLockLocked.hide()
		$BasementDoorClosed.hide()
		$BasementDoorOpen.show()
	if backdoor_state == DoorState.Closed:
		$BackdoorLockUnlocked.show()
		$BackdoorLockLocked.hide()
		$BackdoorClosed.show()
		$BackdoorOpen.hide()
	if backdoor_state == DoorState.Locked:
		$BackdoorLockUnlocked.hide()
		$BackdoorLockLocked.show()
		$BackdoorClosed.show()
		$BackdoorOpen.hide()
	if backdoor_state == DoorState.Open:
		$BackdoorLockUnlocked.hide()
		$BackdoorLockLocked.hide()
		$BackdoorClosed.hide()
		$BackdoorOpen.show()



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
	$Monica.position = state_info["player_position"] + Vector2(20, 0)

func carbunkle_arrives():
	backdoor_state = DoorState.Open
	$Carbunkle.show()


func _on_carbunkle_entered(body: Node2D) -> void:
	if body == $Monica:
		death.emit()
