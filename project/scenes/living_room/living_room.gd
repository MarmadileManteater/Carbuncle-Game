extends DefaultScene

var possible_drawers = ["open_dph", "open_key", "open_empty"]
var looked_in_couch = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if $Drawer.animation == "open_empty":
		$Clickable.remove_child($Clickable/Drawer)

	if looked_in_couch:
		$Clickable.remove_child($Clickable/Couch)
	update_carbunkle_location(carbunkle_location)
	if came_from == "kitchen":
		$Monica.position = $RightEntrance.position
	
	$"Couch Cushions".next_line.connect(
		func (line_number):
			if line_number == 0:
				if searches == 0:
					$"Couch Cushions/Dialog2".text = "I wondered where my diphenhydramine went."
				if searches == 1:
					$"Couch Cushions/Dialog2".text = "Wow, look nothing!"
				if searches == 2:
					$"Couch Cushions/Dialog2".text = "[i]Key obtained successfully![/i]"
			if line_number == 1:
				if searches == 0:
					item_obtained.emit("dph")
				if searches == 2:
					item_obtained.emit("key")
				search.emit()
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if $Carbunkle.visible:
			$Carbunkle.position -= ($Carbunkle.position - $Monica.position).normalized()


func _on_left_door_body_entered(body: Node2D) -> void:
	if body == $Monica:
		change_scene.emit("room_with_window")


func _on_kitchen_entered(body: Node2D) -> void:
	if body == $Monica:
		change_scene.emit("kitchen")

func clickable_clicked(node: VirtualClickable) -> void:
	super(node)
	if node.name == "Couch":
		if not looked_in_couch:
			looked_in_couch = true
			$"Couch Cushions".advance()
			$"Couch Cushions".done.connect(func ():
				enable_clickable()	
			)
			disable_clickable()
	if node.name == "Drawer":
		if $Drawer.animation == "default":
			$Drawer/AudioStreamPlayer2D.play()
			if searches == 0:
				$Drawer.play("open_dph")
			if searches == 1:
				$Drawer.play("open_empty")
				item_obtained.emit("nothing")
			if searches == 2:
				$Drawer.play("open_key")
			search.emit()
		elif $Drawer.animation == "open_dph":
			$Drawer.play("open_empty")
			item_obtained.emit("dph")
		elif $Drawer.animation == "open_key":
			$Drawer.play("open_empty")
			item_obtained.emit("doorkey")
	if node.name == "Bookshelf":
		$Books.advance()
		$Books.done.connect(
			func():
				enable_clickable()
		)
		disable_clickable()
func save_state() -> Dictionary:
	return {
		"drawer": $Drawer.animation,
		"looked_in_couch": looked_in_couch
	}
	
func load_state(state_info: Dictionary) -> void:
	$Drawer.play(state_info["drawer"])
	looked_in_couch = state_info["looked_in_couch"]

func update_carbunkle_location(location: CarbunkleState.Location) -> void:
	$MonsterBehindDoor.hide()
	$MonsterBehindWindow.hide()
	if location == CarbunkleState.Location.FrontDoor:
		$MonsterBehindDoor.show()
	if location == CarbunkleState.Location.LivingRoomWindow:
		$MonsterBehindWindow.show()

func carbunkle_arrives():
	$Carbunkle.show()

func _on_carbunkle_entered(body: Node2D) -> void:
	if body == $Monica:
		if $Carbunkle.visible:
			death.emit()
