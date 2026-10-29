extends DefaultScene

var is_clicked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_done_area_entered(body: Node2D) -> void:
	if body == $Driver/CharacterBody:
		$Driver/AnimationPlayer.play_backwards("RotateIn")
		unlock_cursor()

func _on_piece_click(node: PuzzlePiece) -> void:
	cursor_change(VirtualCursor.Type.Grab)
	lock_cursor(node)
	is_clicked = true

func _on_piece_unclick() -> void:
	unlock_cursor()
	cursor_change(VirtualCursor.Type.Notice)
	is_clicked = false

func _on_piece_hover() -> void:
	if not is_clicked:
		cursor_change(VirtualCursor.Type.Notice)
	#cursor_change("point")
	
func _on_piece_unhover() -> void:
	if not is_clicked:
		cursor_change(VirtualCursor.Type.Default)
	#cursor_change("default")

func _on_driver_click() -> void:
	_on_piece_click($Driver)

func _on_puzzle_piece_8_click() -> void:
	_on_piece_click($PuzzlePiece8)

func _on_puzzle_piece_7_click() -> void:
	_on_piece_click($PuzzlePiece7)

func _on_puzzle_piece_6_click() -> void:
	_on_piece_click($PuzzlePiece6)

func _on_puzzle_piece_5_click() -> void:
	_on_piece_click($PuzzlePiece5)

func _on_puzzle_piece_4_click() -> void:
	_on_piece_click($PuzzlePiece4)

func _on_puzzle_piece_3_click() -> void:
	_on_piece_click($PuzzlePiece3)

func _on_puzzle_piece_2_click() -> void:
	_on_piece_click($PuzzlePiece2)

func _on_puzzle_piece_click() -> void:
	_on_piece_click($PuzzlePiece)

func _on_animation_finished(anim_name: StringName) -> void:
	_on_piece_unclick()
	_on_piece_unhover()
