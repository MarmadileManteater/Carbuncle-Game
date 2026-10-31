extends DefaultScene

var possible_drawers = ["open_dph", "open_key", "open_empty"]
var looked_in_couch = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
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
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
			if searches == 0:
				$Drawer.play("open_dph")
				$Drawer/AudioStreamPlayer2D.play()
			if searches == 1:
				$Drawer.play("open_empty")
			if searches == 2:
				$Drawer.play("open_key")
				$Drawer/AudioStreamPlayer2D.play()
		elif $Drawer.animation == "open_dph":
			$Drawer.play("open_empty")
			item_obtained.emit("dph")
		elif $Drawer.animation == "open_key":
			$Drawer.play("open_empty")
			item_obtained.emit("doorkey")

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
