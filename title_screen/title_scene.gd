extends CanvasLayer

#region /// On ready variables
@onready var main_menu: VBoxContainer = %MainMenu
@onready var new_game_menu: VBoxContainer = %NewGameMenu
@onready var load_game_menu: VBoxContainer = %LoadGameMenu

@onready var new_game_button: Button = %NewGame
@onready var load_game_button: Button = %LoadGame
@onready var tutorial: Button = %Tutorial

@onready var new_slot_01: Button = %NewSlot01
@onready var new_slot_02: Button = %NewSlot02
@onready var new_slot_03: Button = %NewSlot03

@onready var load_slot_01: Button = %LoadSlot01
@onready var load_slot_02: Button = %LoadSlot02
@onready var load_slot_03: Button = %LoadSlot03

@onready var animation_player: AnimationPlayer = $Control/MainMenu/Logo/AnimationPlayer
@onready var player_spawn: Node2D = $Tutorial/PlayerSpawn
#endregion

const PLAYER = preload("res://player/player.tscn")

func _ready() -> void:
	connect_button_signals()
	show_main_menu()
	animation_player.animation_finished.connect(_on_animation_finished)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if main_menu.visible == false:
			show_main_menu()

func show_main_menu() -> void:
	for c in $Tutorial.get_children():
		c.visible = false
	for c in $Control.get_children():
		c.visible = true
	$Control.show()
	for c in get_children():
		if c is Player:
			c.queue_free()
	main_menu.visible = true
	$Control/ColorRect.show()
	$Control/TileMapContainer.show()
	new_game_menu.visible = false
	load_game_menu.visible = false
	new_game_button.grab_focus()

func connect_button_signals() -> void:
	new_game_button.pressed.connect(show_new_game_menu)
	load_game_button.pressed.connect(show_load_game_menu)
	new_slot_01.pressed.connect(on_new_game_pressed.bind(0))
	new_slot_02.pressed.connect(on_new_game_pressed.bind(1))
	new_slot_03.pressed.connect(on_new_game_pressed.bind(2))
	load_slot_01.pressed.connect(on_load_game_pressed.bind(0))
	load_slot_02.pressed.connect(on_load_game_pressed.bind(1))
	load_slot_03.pressed.connect(on_load_game_pressed.bind(2))
	tutorial.pressed.connect(show_tutorial)

func show_tutorial() -> void:
	for c in get_children():
		c.visible = false
	$Tutorial.visible = true
	for c in $Tutorial.get_children():
		c.visible = true
	$Control/TileMapContainer/TileMap.collision_enabled = false
	%MainMenu.hide()
	var player_inst = PLAYER.instantiate()
	$Tutorial.add_child(player_inst)
	player_inst.global_position = player_spawn.global_position
	await get_tree().process_frame
	player_inst.reparent(self)

func show_new_game_menu() -> void:
	main_menu.visible = false
	new_game_menu.visible = true
	load_game_menu.visible = false
	
	new_slot_01.grab_focus()
	
	if SaveManager.save_file_exists(0):
		new_slot_01.text = "Replace Slot 01"
		
	if SaveManager.save_file_exists(1):
		new_slot_02.text = "Replace Slot 02"
		
	if SaveManager.save_file_exists(2):
		new_slot_03.text = "Replace Slot 03"

func show_load_game_menu() -> void:
	main_menu.visible = false
	new_game_menu.visible = false
	load_game_menu.visible = true
	load_slot_01.grab_focus()
	load_slot_01.disabled = !SaveManager.save_file_exists(0)
	load_slot_02.disabled = !SaveManager.save_file_exists(1)
	load_slot_03.disabled = !SaveManager.save_file_exists(2)

func on_new_game_pressed(slot:int) -> void:
	delete_tutorial()
	SaveManager.create_new_game_save(slot)

func on_load_game_pressed(slot:int) -> void:
	delete_tutorial()
	SaveManager.load_game(slot)

func delete_tutorial() -> void:
	$Tutorial.queue_free()

func _on_animation_finished(_name:String) -> void:
	if _name == "start":
		animation_player.play("loop")
	else:
		return
