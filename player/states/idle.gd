class_name PlayerStateIdle extends PlayerState

# What happens when this state is initialized?
func init() -> void:
	pass

# What happens when this state is entered?
func enter() -> void:
	if player.previous_state == run:
		player.animation_player.play("idle")
	else:
		player.animation_player.queue("idle")

# What happens when this state is exited?
func exit() -> void:
	pass

# What happens when an input is pressed?
func handle_input(_event:InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump"):
		return jump
	return next_state

# What happens each process tick in this state?
func process(_delta:float) -> PlayerState:
	if player.direction.x != 0:
		return run
	elif player.direction.y > 0.5:
		return crouch
	return next_state

# What happens each physics_process tick in this state?
func physics_process(_delta:float) -> PlayerState:
	player.velocity.x = 0
	if player.is_on_floor() == false:
		return fall
	return next_state
