@tool
extends DefaultScene

enum LockPosition { Left, Right }

@export var lock_start: LockPosition = LockPosition.Right

var is_clicked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var pieces = find_children("PuzzlePiece*")
	for piece in pieces:
		var p: PuzzlePiece = piece
		p.click.connect(
			func ():
				_on_piece_click(p)
		)
		p.hover.connect(
			func ():
				_on_piece_hover()
				
		)
		p.unclick.connect(
			func ():
				_on_piece_unclick()
		)
		p.unhover.connect(
			func ():
				_on_piece_unhover()
		)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if lock_start == LockPosition.Right:
			$DoneArea/CollisionShape2D.position = $LeftEnd.position
			$Driver.position = $RightStart.position
		if lock_start == LockPosition.Left:
			$DoneArea/CollisionShape2D.position = $RightEnd.position
			$Driver.position = $LeftStart.position

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
	
func _on_piece_unhover() -> void:
	if not is_clicked:
		cursor_change(VirtualCursor.Type.Default)

func _on_driver_click() -> void:
	_on_piece_click($Driver)

func _on_animation_finished(anim_name: StringName) -> void:
	_on_piece_unclick()
	_on_piece_unhover()
