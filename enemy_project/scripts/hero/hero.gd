extends KinematicBody2D

enum {STATE_MOVE, STATE_STAND, STATE_AIR}

export(float) var ground_max_velocity := 8.0 * 16.0
export(float, 0.01, 2.0) var ground_turn_time := 0.1
export(float, 0.01, 2.0) var ground_accel_time := 0.25
export(float, 0.01, 2.0) var ground_fric_time := 0.2

export(float) var air_max_velocity := 9.0 * 16.0
export(float, 0.01, 5.0) var air_turn_time := 0.7
export(float, 0.01, 5.0) var air_accel_time := 0.9
export(float, 0.01, 5.0) var air_fric_time := 2.0

export(float) var gravity := 8.0
export(float) var jump_force := 150.0
export(float, 0.0, 1.0) var buffering_time := 0.25
export(float, 0.0, 1.0) var coyte_time := 0.1

onready var _ground_fric = ground_max_velocity / (ground_fric_time * _engine_fps) #fps
onready var _ground_accel = ground_max_velocity / (ground_accel_time * _engine_fps) #fps
onready var _ground_turn_accel = ground_max_velocity / (ground_turn_time * _engine_fps) #fps
onready var _air_fric = air_max_velocity / (air_fric_time * _engine_fps) #fps
onready var _air_accel = air_max_velocity / (air_accel_time * _engine_fps) #fps
onready var _air_turn_accel = air_max_velocity / (air_turn_time * _engine_fps) #fps

onready var _default_buffering_time = buffering_time
onready var _default_coyte_time = coyte_time
var _actual_state = STATE_STAND
var _velocity := Vector2.ZERO
var _direction := 0.0
var _jump_pressed : bool = false
var _was_jumped : bool = false
var _engine_fps = Engine.iterations_per_second


func _physics_process(delta):
	_direction = _get_direction()
	
	match _actual_state:
		STATE_STAND:
			
			_velocity.x = max(abs(_velocity.x) - _ground_fric, 0.0) * sign(_velocity.x)
			
			if _direction != 0:
				_actual_state = STATE_MOVE
			
			if Input.is_action_just_pressed("ui_up") and is_on_floor():
				jump()
			
			if not is_on_floor():
				_actual_state = STATE_AIR
			
			
		STATE_MOVE:
			
			movement(_ground_accel, _ground_turn_accel, ground_max_velocity)
			
			if _direction == 0.0:
				_actual_state = STATE_STAND
			
			if Input.is_action_just_pressed("ui_up") and is_on_floor():
				jump()
			
			if not is_on_floor():
				_actual_state = STATE_AIR
		
		STATE_AIR:
			movement(_air_accel, _air_turn_accel, air_max_velocity)
			
			if _direction == 0.0:
				_velocity.x = max(abs(_velocity.x) - _air_fric, 0.0) * sign(_velocity.x)
			
			if Input.is_action_just_pressed("ui_up"):
				_jump_pressed = true
			
			if Input.is_action_just_pressed("ui_up") and coyte_time > 0 and not _was_jumped:
				jump()
			
			coyte_time -= delta
			
			if _jump_pressed:
				buffering_time -= delta
			
			
			if is_on_floor():
				if _jump_pressed and buffering_time > 0:
					jump()
				_jump_pressed = false
				_was_jumped = false
				buffering_time = _default_buffering_time
				coyte_time = _default_coyte_time
				_actual_state = STATE_STAND
			
	_velocity.y += gravity
	
	_velocity = move_and_slide(_velocity, Vector2.UP)


func _get_direction() -> float:
	return sign(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))


func jump():
	_velocity.y = -jump_force
	_was_jumped = true


func movement(accel:float, turn_accel:float, max_velocity:float) -> void:
	if _direction != 0.0:
		if _direction == sign(_velocity.x) or is_equal_approx(_velocity.x, 0):
			_velocity.x += accel * _direction
		
		else:
			_velocity.x += turn_accel * _direction
		
		_velocity.x = clamp(_velocity.x, -max_velocity, max_velocity)

