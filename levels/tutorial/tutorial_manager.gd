@tool
extends Node2D

var editor_selection:EditorSelection
var tutorial_nodes:Array[TutorialNode]

func _ready() -> void:
	if Engine.is_editor_hint():
		var editor_plugin:EditorPlugin = EditorPlugin.new()
		editor_selection = editor_plugin.get_editor_interface().get_selection()
		editor_selection.selection_changed.connect(_on_selection_changed)
	else:
		for c in get_children():
			if c is TutorialNode:
				tutorial_nodes.append(c)
		for n in tutorial_nodes:
			n.hide()
		tutorial_go()

func _on_selection_changed():
	if !Engine.is_editor_hint():
		return
	var selection = editor_selection.get_selected_nodes()
	for c in get_children():
		if c is TutorialNode:
			c.hide()
	if selection.size() > 1:
		return
	elif selection.size() == 0:
		return
	else:
		selection[0].visible = true

func tutorial_go(index:int = 0):
	var tutorial_node_active:TutorialNode = tutorial_nodes[index]
	tutorial_node_active.show()
	if tutorial_node_active.actions_to_press.size() == 0:
		return
	for action in tutorial_node_active.actions_to_press:
		if Input.is_action_pressed(action):
			tutorial_node_active.hide()
			tutorial_go(index + 1)
			return
	await get_tree().process_frame
	tutorial_go(index)
	return
