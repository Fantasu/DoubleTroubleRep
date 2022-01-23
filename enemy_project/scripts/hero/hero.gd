extends KinematicBody2D

enum {STATE_MOVE, STATE_STAND, STATE_AIR}

var max_velocity = 8 * 16
var accel_time = 0.25
var fric_time = 0.20
var gravity = 5
var jump_force = 100
var buffering_time = 0.25
var coyte_time = 0.10

onready var _accel = max_velocity / (accel_time * 60) #fps
onready var _fric = max_velocity / (fric_time * 60) #fps
onready var _default_buffering_time = buffering_time
onready var _default_coyte_time = coyte_time
var _actual_state = STATE_STAND
var _velocity := Vector2.ZERO
var _direction := 0.0
var _jump_pressed : bool = false
var _was_jumped : bool = false

func _physics_process(delta):
	_direction = _get_direction()
	
	match _actual_state:
		STATE_STAND:
			
			_velocity.x = max(abs(_velocity.x) - _fric, 0.0) * sign(_velocity.x)
			
			if _direction != 0:
				_actual_state = STATE_MOVE
			
			if Input.is_action_just_pressed("ui_up") and is_on_floor():
				jump()
			
			if not is_on_floor():
				_actual_state = STATE_AIR
			
			
		STATE_MOVE:
			
			if _direction != 0.0:
				_velocity.x += _accel * _direction
				_velocity.x = clamp(_velocity.x, -max_velocity, max_velocity)
			
			else:
				_actual_state = STATE_STAND
			
			if Input.is_action_just_pressed("ui_up") and is_on_floor():
				jump()
			
			if not is_on_floor():
				_actual_state = STATE_AIR
		
		STATE_AIR:
			
			if _direction != 0.0:
				_velocity.x += _accel * _direction
				_velocity.x = clamp(_velocity.x, -max_velocity, max_velocity)
			
			else:
				_velocity.x = max(abs(_velocity.x) - _fric, 0.0) * sign(_velocity.x)
			
			if Input.is_action_just_pressed("ui_up") and _was_jumped:
				_jump_pressed = true
			
			elif Input.is_action_just_pressed("ui_up") and coyte_time > 0 and not _was_jumped:
				jump()
			
			
			coyte_time -= delta
			
			if _jump_pressed:
				buffering_time -= delta
			
			
			if is_on_floor():
				if _jump_pressed and buffering_time > 0:
					jump()
				_jump_pressed = false
				_was_jumped = false
				coyte_time = _default_coyte_time
				buffering_time = _default_buffering_time
				_actual_state = STATE_STAND
			
	_velocity.y += gravity
	
	_velocity = move_and_slide(_velocity, Vector2.UP)


func _get_direction() -> float:
	return sign(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))


func jump():
	_velocity.y = -jump_force
	_was_jumped = true
