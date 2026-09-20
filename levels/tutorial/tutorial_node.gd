@tool
class_name TutorialNode
extends PanelContainer

@export_multiline() var tutorial_text:String = "Test Tutorial" : 
	set(new_val):
		tutorial_text = new_val
		update_label_text()
@export var actions_to_press:Array[String] = [""]

@onready var label: Label = $Label

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	label = $Label
	label.text = tutorial_text

func update_label_text():
	if Engine.is_editor_hint():
		for c in get_children():
			if c is Label:
				label = c
		label = $Label
		label.text = tutorial_text
