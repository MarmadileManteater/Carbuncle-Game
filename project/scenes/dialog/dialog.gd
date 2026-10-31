@tool
extends Node2D

class_name Dialog

enum Portrait { None, Monica, Monster }
enum Direction { Left, Right }

signal done

@export var text: String
@export var portrait: Portrait
@export var portrait_position: Direction = Direction.Right
@export var pitch_scale: float = 1

var left_text: String

func play() -> void:
    $RichTextLabel/Arrow.hide()
    left_text = text
    $Timer.timeout.connect(
        func ():
            var character = ""
            var keep_going = true
            while keep_going:
                character += left_text[0]
                left_text = left_text.substr(1)
                if not character.begins_with("["):
                    keep_going = false
                elif character.ends_with("]"):
                    keep_going = false
                if left_text.length() == 0:
                    keep_going = false
            $RichTextLabel.text += character
            if not $Chirp.playing:
                $Chirp.pitch_scale = pitch_scale
                $Chirp.play()
            if left_text.length() == 0:
                $Timer.stop()
                done.emit()
                $RichTextLabel/Arrow.show()
    )
    $Timer.start()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if not Engine.is_editor_hint():
        $RichTextLabel.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if portrait == Portrait.None:
        $RichTextLabel.size.x = 1328.0
        $RichTextLabel/Arrow.position.x = 1300
    else:
        $RichTextLabel.size.x = 1038.0
        $RichTextLabel/Arrow.position.x = 1014.0
    if portrait == Portrait.Monica:
        $Portraits/Monica.show()
    else:
        $Portraits/Monica.hide()
    if portrait == Portrait.Monster:
        $Portraits/Monster.show()
    else:
        $Portraits/Monster.hide()
    
    if portrait_position == Direction.Right:
        $Portraits.position = $RightPortraits.position
        $Portraits.scale.x = 1
        $RichTextLabel.position = $LeftText.position
    if portrait_position == Direction.Left:
        $Portraits.position = $LeftPortraits.position
        $Portraits.scale.x = -1
        $RichTextLabel.position = $RightText.position
    if portrait == Portrait.None:
        $RichTextLabel.position = $LeftText.position
    
    if Engine.is_editor_hint():
        $RichTextLabel.text = text
