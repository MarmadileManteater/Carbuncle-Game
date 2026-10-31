@tool
extends DefaultScene

enum DoorState { Closed, Locked, Open }

@export var backdoor_state: DoorState = DoorState.Closed

@export var basement_state: DoorState = DoorState.Locked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if not is_basement_door_locked:
		basement_state = DoorState.Closed
	if is_kitchen_door_locked:
		backdoor_state = DoorState.Locked
		$Clickable.remove_child($Clickable/BackdoorLock)
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
	if node.name == "BasementLock":
		if basement_state == DoorState.Locked:
			change_scene.emit("lock_puzzle_3")
		elif basement_state == DoorState.Closed:
			if items["doorkey"]:
				change_scene.emit("basement")
			else:
				$NoKey.advance()
				$NoKey.done.connect(
					func():
						$NoKey.hide()
						enable_clickable()
						$Clickable.remove_child($Clickable/FridgeNote)
				)
				disable_clickable()
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
	if node.name == "Drawer":
		if $Fridge.animation == "default":
			$Fridge/AudioStreamPlayer2D.play()
			if searches == 0:
				$Fridge.play("open_dph")
			if searches == 1:
				$Fridge.play("open_empty")
				item_obtained.emit("nothing")
			if searches == 2:
				$Fridge.play("open_key")
			search.emit()
		elif $Fridge.animation == "open_dph":
			item_obtained.emit("dph")
			$Fridge.play("open_empty")
		elif $Fridge.animation == "open_key":
			item_obtained.emit("doorkey")
			$Fridge.play("open_empty")
				
func save_state() -> Dictionary:
	return {
		"player_position": $Monica.position,
		"fridge": $Fridge.animation
	}

func load_state(state_info: Dictionary):
	$Monica.position = state_info["player_position"] + Vector2(20, 0)
	$Fridge.animation = state_info["fridge"]

func carbunkle_arrives(direction: DefaultScene.Direction):
	if direction == DefaultScene.Direction.Right:
		backdoor_state = DoorState.Open
		$Carbunkle.show()
	else:
		$Carbunkle.position = $CarbunkleLeft.position
		$Carbunkle.flip_h = true
		$Carbunkle.show()


func _on_carbunkle_entered(body: Node2D) -> void:
	if body == $Monica:
		if $Carbunkle.visible:
			death.emit()
