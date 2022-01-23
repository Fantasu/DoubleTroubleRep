extends State

var ground_accel : float = 0 
var ground_turn_accel : float = 0
var enter_direction : float = 0

func _init():
	state_name = 'move'


func enter(_previous_state):
	.enter(_previous_state)
	
	enter_direction = actor._direction
	ground_turn_accel = actor.max_horizontal_ground_velocity / (actor.ground_turn_time * Engine.iterations_per_second)
	ground_accel = actor.max_horizontal_ground_velocity / (actor.ground_accel_time * Engine.iterations_per_second)


func physics_update(_delta:float) -> void:
	actor._direction = actor.get_direction()
	
#	print(actor._direction)
	
	if actor._direction == enter_direction:
		movement(_delta)
	
	elif actor._direction == 0:
		statemachine.change_state('stand')
	
	else:
		enter_direction = actor._direction
	
	if Input.is_action_pressed('ui_up') and actor.is_on_floor():
		actor.jump()
	
	actor._velocity.y += actor._gravity_rising/2 * _delta
	actor._velocity = actor.move_and_slide(actor._velocity, Vector2.UP,false, 4, PI/4, false)

	if not actor.is_on_floor():
		actor._coyote_timer += _delta
		statemachine.change_state('air')

func update(_delta):
	pass


func movement(delta : float) -> void:
	var same_direction = sign(actor._direction) == sign(actor._velocity.x)
	var stoped = sign(actor._velocity.x) == 0
	
	if same_direction or stoped:
		actor._velocity.x += ground_accel * actor._direction
	
	else:
		actor._velocity.x += ground_turn_accel * actor._direction
	
	actor._velocity.x = clamp(actor._velocity.x, -actor.max_horizontal_ground_velocity, actor.max_horizontal_ground_velocity)


func exit():
	actor.jump_buffering_timer = actor._default_buffering_timer
