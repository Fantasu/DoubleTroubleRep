extends KinematicBody2D
class_name Hero

enum {STATE_MOVE, STATE_STAND, STATE_AIR}

const TILE_SIZE = 16

export(float) var ground_max_velocity := 7.0 * TILE_SIZE
export(float, 0.01, 2.0) var ground_turn_time := 0.15
export(float, 0.01, 2.0) var ground_accel_time := 0.2
export(float, 0.01, 2.0) var ground_fric_time := 0.15

export(float) var air_max_velocity := 7.5 * TILE_SIZE
export(float, 0.01, 5.0) var air_turn_time := 0.25
export(float, 0.01, 5.0) var air_accel_time := 0.55
export(float, 0.01, 5.0) var air_fric_time := 0.75

var jump_size = 2.2 * TILE_SIZE
var min_jump_size = 1.1 * TILE_SIZE
var fall_time = 0.65
var gravity = 2 * jump_size / (pow(fall_time, 2)/2) 
var jump_force = sqrt(2 * gravity * jump_size)

export(float, 0.0, 1.0) var buffering_time := 0.20
export(float, 0.0, 1.0) var coyote_time := 0.20

onready var _gravity_multiplier = jump_size/min_jump_size
onready var _ground_fric = ground_max_velocity / (ground_fric_time * _engine_fps) #fps
onready var _ground_accel = ground_max_velocity / (ground_accel_time * _engine_fps) #fps
onready var _ground_turn_accel = ground_max_velocity / (ground_turn_time * _engine_fps) #fps
onready var _air_fric = air_max_velocity / (air_fric_time * _engine_fps) #fps
onready var _air_accel = air_max_velocity / (air_accel_time * _engine_fps) #fps
onready var _air_turn_accel = air_max_velocity / (air_turn_time * _engine_fps) #fps

onready var _default_buffering_time = buffering_time
onready var _default_coyote_time = coyote_time

var _actual_state = STATE_STAND
var _velocity := Vector2.ZERO
var _direction := 0.0
var _jump_pressed : bool = false
var _was_jumped : bool = false
var _engine_fps = Engine.iterations_per_second
var _g_multiplier = 1


func _physics_process(delta):
	_direction = _get_direction()
	
	match _actual_state:
		STATE_STAND:
			
			flip_nodes()
			_velocity.x = max(abs(_velocity.x) - _ground_fric, 0.0) * sign(_velocity.x)
			
			if _direction != 0:
				_actual_state = STATE_MOVE
			
			if Input.is_action_just_pressed("ui_up") and is_on_floor():
				jump()
			
			if not is_on_floor():
				_actual_state = STATE_AIR
			
			
		STATE_MOVE:
			flip_nodes()
			movement(_ground_accel, _ground_turn_accel, ground_max_velocity)
			
			if _direction == 0.0:
				_actual_state = STATE_STAND
			
			if Input.is_action_just_pressed("ui_up") and is_on_floor():
				jump()
			
			if not is_on_floor():
				_actual_state = STATE_AIR
		
		STATE_AIR:
			flip_nodes()
			movement(_air_accel, _air_turn_accel, air_max_velocity)
			
			if _direction == 0.0:
				_velocity.x = max(abs(_velocity.x) - _air_fric, 0.0) * sign(_velocity.x)
			
			if Input.is_action_just_pressed("ui_up"):
				_jump_pressed = true
			
			if Input.is_action_just_pressed("ui_up") and coyote_time > 0 and not _was_jumped:
				_g_multiplier = 1
				jump()
				
			if (not Input.is_action_pressed("ui_up") and _was_jumped) or _velocity.y > 0:
				_g_multiplier = _gravity_multiplier
			
			coyote_time -= delta
			
			if _jump_pressed:
				buffering_time -= delta
			
			
			if is_on_floor():
				_was_jumped = false
				if _jump_pressed and buffering_time > 0:
					jump()
				_jump_pressed = false
				buffering_time = _default_buffering_time
				coyote_time = _default_coyote_time
				_g_multiplier = 1
				_actual_state = STATE_STAND
			
	_velocity.y += gravity * delta * _g_multiplier
	
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


func flip_nodes():
	if _direction:
		$Flip.scale.x = _direction
