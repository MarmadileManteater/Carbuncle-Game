class_name CarbunkleState

enum Location { Walking, FrontDoor, BedroomWindow, LivingRoomWindow, KitchenDoor }

var location: Location = Location.Walking
var phase: int = 1

func get_distance(scene_name: String) -> float:
	var distance = 0
	if location == Location.FrontDoor:
		if scene_name == "room_with_window":
			distance = 1
		if scene_name == "window":
			distance = 1
		if scene_name == "kitchen":
			distance = 2
	if location == Location.BedroomWindow:
		if scene_name == "living_room":
			distance = 1
		if scene_name == "kitchen":
			distance = 2
	if location == Location.LivingRoomWindow:
		if scene_name == "room_with_window":
			distance = 1
		if scene_name == "window":
			distance = 1
		if scene_name == "kitchen":
			distance = 1
	if location == Location.KitchenDoor:
		if scene_name == "room_with_window":
			distance = 2
		if scene_name == "window":
			distance = 2
		if scene_name == "living_room":
			distance = 1
	
	return distance

func get_sound(is_kitchen_door_locked: bool):
	var sound: SoundMachine.Sound
	if location == Location.FrontDoor:
		if phase == 2:
			sound = SoundMachine.Sound.Knocking
		if phase == 3:
			sound = SoundMachine.Sound.Banging
		if phase == 4:
			sound = SoundMachine.Sound.Jiggling
		if phase == 5:
			sound = SoundMachine.Sound.TryBreaking
		if phase == 6:
			sound == SoundMachine.Sound.Busted
		
	if location == Location.BedroomWindow or location == Location.LivingRoomWindow:
		sound = SoundMachine.Sound.WindowKnocking
	
	if location == Location.KitchenDoor:
		if is_kitchen_door_locked:
			if phase == 2:
				sound = SoundMachine.Sound.Knocking
			if phase == 3:
				sound = SoundMachine.Sound.Banging
			if phase == 4:
				sound = SoundMachine.Sound.Jiggling
			if phase == 5:
				sound = SoundMachine.Sound.TryBreaking
			if phase == 6:
				sound = SoundMachine.Sound.Busted
		else:
			sound = SoundMachine.Sound.Opening
	return sound
