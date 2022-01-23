extends State

var ground_friction : float

func _init():
	state_name = 'stand'


func enter(_previous_state):
	.enter(_previous_state)
	
	ground_friction = actor.max_horizontal_ground_velocity / (actor.ground_fric_time * Engine.iterations_per_second)


func physics_update(_delta):
	actor._direction = actor.get_direction()
	
	#applying friction
	actor._velocity.x = max(abs(actor._velocity.x) - ground_friction, 0) * sign(actor._velocity.x)
	
	actor._velocity.y += actor._gravity_rising/2 * _delta
	actor._velocity = actor.move_and_slide(actor._velocity, Vector2.UP,false, 4, PI/4, false)
	
	if not actor._direction == 0:
		statemachine.change_state('move')
	
	if not actor.is_on_floor():
		statemachine.change_state('air')
	
	if Input.is_action_pressed("ui_up") and actor.is_on_floor():
		actor.jump()


func update(_delta):
	pass


func exit():
	pass
