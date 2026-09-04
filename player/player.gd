class_name Player extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://1n5lkptfbcul")

#region /// export variables
@export var move_speed:float = 150.0
#endregion

#region /// State Machine Variables
var states:Array[PlayerState]
var current_state:PlayerState : 
	get : return states.front()
var previous_state:PlayerState :
	get : return states[1]
#endregion

#region /// Standard Variables
var direction:Vector2 = Vector2.ZERO
var gravity:float = 980.0
#endregion

func _ready() -> void:
	initialize_states()

func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))

func _process(delta: float) -> void:
	update_direction()
	change_state(current_state.process(delta))

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	move_and_slide()
	change_state(current_state.physics_process(delta))
	$Label.text = current_state.name

func initialize_states() -> void:
	states = []
	#gather all the states
	for c in $States.get_children():
		if c is PlayerState:
			states.append(c)
			c.player = self
	
	if states.size() == 0:
		return
	
	#initialize all the states
	for state in states:
		state.init()
	
	#set our first state
	change_state(current_state)
	current_state.enter()


func change_state(new_state:PlayerState) -> void:
	#fail safes
	if new_state == null:
		return
	elif new_state == current_state:
		return
	
	#exit the current state
	if current_state:
		current_state.exit()
	
	#enter the new state
	states.push_front(new_state)
	current_state.enter()
	states.resize(3)
	$Label.text = current_state.name

func update_direction() -> void:
	#var prev_direction:Vector2 = direction
	
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	
	#do more stuff?

func add_debug_indicator(color:Color = Color.RED):
	var d:Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child(d)
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer(3.0).timeout
	d.queue_free()
