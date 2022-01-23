extends State

var air_turn_accel : float = 0
var air_friction : float = 0
var air_friction_no_walk : float = 0
var air_acceleration : float = 0
var current_direction : int
var jump_buffering_pressed := false

func _init():
	state_name = 'air'


func enter(_previous_state):
	.enter(_previous_state)
	
	air_acceleration = actor.max_horizontal_air_velocity / (actor.air_accel_time * Engine.iterations_per_second)
	air_turn_accel = actor.max_horizontal_air_velocity / (actor.air_turn_time * Engine.iterations_per_second)
	air_friction = actor.max_horizontal_air_velocity / (actor.air_fric_time * Engine.iterations_per_second)


func physics_update(_delta):
	actor._direction = actor.get_direction()
	
	if not actor._direction == 0: 
		air_movement(_delta)
	
	else:
		#friction
		actor._velocity.x = max(abs(actor._velocity.x) - air_friction, 0) * sign(actor._velocity.x)
	
	if not Input.is_action_pressed("ui_up") \
	and actor._was_jumped \
	and actor._velocity.y < -actor._min_jump_velocity:
		actor._velocity.y = -actor._min_jump_velocity
	
	if Input.is_action_pressed("ui_up") and actor._velocity.y > 0:
		jump_buffering_pressed = true
		actor._was_buffering_pressed = true
	
	if Input.is_action_just_pressed("ui_up") \
	and actor._coyote_timer <= actor.coyote_limit \
	and not actor._was_jumped:
		actor.jump()
	
	jump_buffering(_delta)
	set_rising_to_falling(_delta)
	actor._coyote_timer += _delta
	
	actor._velocity.y = clamp(actor._velocity.y, -actor.max_horizontal_air_velocity * 100, actor.max_horizontal_air_velocity * 100)
	actor._velocity = actor.move_and_slide(actor._velocity, Vector2.UP,false, 4, PI/4, false)
	
	
	if actor.is_on_floor():
		statemachine.change_state('stand')
		

func air_movement(_delta):
	var same_direction = sign(actor._direction) == sign(actor._velocity.x)
	var stoped = sign(actor._velocity.x) == 0
	
	if same_direction or stoped:
		actor._velocity.x += air_acceleration * actor._direction
	else:
		actor._velocity.x += air_turn_accel * actor._direction
	
	actor._velocity.x = clamp(actor._velocity.x, -actor.max_horizontal_air_velocity, actor.max_horizontal_air_velocity)


func set_rising_to_falling(_delta:float) -> void:
	if actor._velocity.y < 0:
		actor._velocity.y += actor._gravity_rising * _delta
	else:
		actor._velocity.y += actor._gravity_falling * _delta


func jump_buffering(_delta) -> void:
	if jump_buffering_pressed == true:
		actor.jump_buffering_timer -= _delta


func exit():
	if actor.is_on_floor() == true:
		actor._coyote_timer = 0
		actor._was_jumped = false
		jump_buffering_pressed = false
