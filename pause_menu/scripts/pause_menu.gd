class_name PauseMenu extends CanvasLayer

#region /// On Ready Variables
@onready var pause_screen: Control = %PauseScreen
@onready var system: Control = %System
@onready var system_menu_button: Button = %SystemMenuButton
@onready var back_to_map_button: Button = %BackToMapButton
@onready var back_to_title_button: Button = %BackToTitleButton
@onready var music_slider: HSlider = %MusicSlider
@onready var ui_slider: HSlider = %UISlider
@onready var sfx_slider: HSlider = %SFXSlider
#endregion

var player:Player

func _ready() -> void:
	show_pause_screen()
	system_menu_button.pressed.connect(show_system_menu)
	setup_system_menu()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		queue_free()
	if pause_screen.visible == true:
		if event.is_action_pressed("right") or event.is_action_pressed("down"):
			system_menu_button.grab_focus()

func show_pause_screen() -> void:
	pause_screen.visible = true
	system.visible = false

func show_system_menu() -> void:
	pause_screen.visible = false
	system.visible = true
	back_to_map_button.grab_focus()

func setup_system_menu() -> void:
	back_to_title_button.pressed.connect(_on_back_to_title_pressed)
	back_to_map_button.pressed.connect(show_pause_screen)

func _on_back_to_title_pressed() -> void:
	SceneManager.transition_scene("res://title_screen/title_scene.tscn", "", Vector2.ZERO, "up")
	get_tree().paused = false
	Messages.back_to_title_screen.emit()
	queue_free()
