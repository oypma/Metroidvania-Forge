class_name Player extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://1n5lkptfbcul")

#region /// on ready variables
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var one_way_platform_shape_cast: ShapeCast2D = $OneWayPlatformShapeCast
@onready var animation_player: AnimationPlayer = $AnimationPlayer
#endregion

#region /// export variables
@export var move_speed:float = 150.0
@export var max_fall_velocity:float = 600.0
#endregion

#region /// State Machine Variables
var states:Array[PlayerState]
var current_state:PlayerState : 
	get : return states.front()
var previous_state:PlayerState :
	get : return states[1]
#endregion

#region /// Player Stats
var hp:float = 20.0
var max_hp:float = 20.0
var dash:bool = false
var double_jump:bool = false
var ground_slam:bool = false
var morph_roll:bool = false
#endregion

#region /// Standard Variables
var direction:Vector2 = Vector2.ZERO
var gravity:float = 980.0
var gravity_multiplier:float = 1.0
#endregion

func _ready() -> void:
	if get_tree().get_first_node_in_group("Player") != self:
		self.queue_free()
	initialize_states()
	self.call_deferred("reparent", get_tree().root)
	Messages.player_healed.connect(_on_player_healed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		Messages.player_interacted.emit(self)
	change_state(current_state.handle_input(event))

func _process(delta: float) -> void:
	update_direction()
	change_state(current_state.process(delta))

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta * gravity_multiplier
	velocity.y = clampf(velocity.y, -1000.0, max_fall_velocity)
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
	var prev_direction:Vector2 = direction
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	
	if prev_direction.x != direction.x:
		if direction.x < 0:
			sprite.flip_h = true
		elif direction.x > 0:
			sprite.flip_h = false

func add_debug_indicator(color:Color = Color.RED):
	var d:Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child(d)
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer(3.0).timeout
	d.queue_free()

func _on_player_healed(amount:float, min_value:float = 0) -> void:
	hp += clampf(amount, min_value, max_hp)
