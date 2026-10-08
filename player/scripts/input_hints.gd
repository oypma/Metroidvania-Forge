@icon("res://general/icons/input_hints.svg")
class_name InputHints extends Node2D

const HINT_MAP : Dictionary = {
	"keyboard" : {
		"interact" : 12,
		"jump" : 9,
		"attack" : 10,
		"dash" : 11,
		"up" : 13,
		"crouch" : 12,
		"close" : 14
	}
}

var controller_type:String = "keyboard"

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	visible = false
	Messages.input_hint_changed.connect(_on_hint_changed)

func _on_hint_changed(hint:String):
	if hint == "":
		visible = false
	else:
		visible = true
		sprite_2d.frame = HINT_MAP[controller_type].get(hint, "0")
