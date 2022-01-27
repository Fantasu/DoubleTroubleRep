extends KinematicBody2D
class_name Actor

enum {STATE_MOVE, STATE_STAND, STATE_AIR}

const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGHT = 2
const TILE_SIZE = 16

export(float) var ground_max_velocity := 7.0 * TILE_SIZE
export(float, 0.01, 2.0) var ground_turn_time := 0.15
export(float, 0.01, 2.0) var ground_accel_time := 0.2
export(float, 0.01, 2.0) var ground_fric_time := 0.15

export(float) var air_max_velocity := 7.5 * TILE_SIZE
export(float, 0.01, 5.0) var air_turn_time := 0.25
export(float, 0.01, 5.0) var air_accel_time := 0.55
export(float, 0.01, 5.0) var air_fric_time := 0.75

export (float) var jump_size = 2.2 * TILE_SIZE
export (float) var min_jump_size = 1.1 * TILE_SIZE
export (float) var fall_time = 0.65
onready var gravity = 2 * jump_size / (pow(fall_time, 2)/2) 
onready var jump_force = sqrt(2 * gravity * jump_size)

export(float, 0.0, 1.0) var buffering_time := 0.20
export(float, 0.0, 1.0) var coyote_time := 0.20

export(bool) var active = true

onready var _gravity_multiplier = jump_size/min_jump_size
onready var _ground_fric = ground_max_velocity / (ground_fric_time * _engine_fps) #fps
onready var _ground_accel = ground_max_velocity / (ground_accel_time * _engine_fps) #fps
onready var _ground_turn_accel = ground_max_velocity / (ground_turn_time * _engine_fps) #fps
onready var _air_fric = air_max_velocity / (air_fric_time * _engine_fps) #fps
onready var _air_accel = air_max_velocity / (air_accel_time * _engine_fps) #fps
onready var _air_turn_accel = air_max_velocity / (air_turn_time * _engine_fps) #fps

onready var _default_buffering_time = buffering_time
onready var _default_coyote_time = coyote_time

var _initial_fall_pos := 2.0
var _fall_distance := 0.0
var _g_multiplier := 1.0
var _direction := 0.0
var _actual_state = STATE_STAND
var _velocity := Vector2.ZERO
var _first_fall : bool = false
var _jump_pressed : bool = false
var _was_jumped : bool = false
var _engine_fps = Engine.iterations_per_second
var _snap_vector = SNAP_DIRECTION * SNAP_LENGHT


func _physics_process(delta):
	_direction = _get_direction()
	manage_animations()
	
	match _actual_state:
		STATE_STAND:
			stand_state(delta)
		
			
		STATE_MOVE:
			move_state(delta)
		
		
		STATE_AIR:
			air_state(delta)
			
	_velocity.y += gravity * delta * _g_multiplier
	
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector2.UP, true)


func stand_state(delta):
	flip_nodes()
	_velocity.x = max(abs(_velocity.x) - _ground_fric, 0.0) * sign(_velocity.x)
	
	if _direction != 0:
		_actual_state = STATE_MOVE
	
	if Input.is_action_just_pressed("ui_up") and active and is_on_floor():
		jump()
	
	if not is_on_floor():
		_actual_state = STATE_AIR


func air_state(delta):
	_snap_vector = Vector2.ZERO
	flip_nodes()
	movement(_air_accel, _air_turn_accel, air_max_velocity)
	calculate_fall_distance()
	
	if _direction == 0.0:
		_velocity.x = max(abs(_velocity.x) - _air_fric, 0.0) * sign(_velocity.x)
	
	if Input.is_action_just_pressed("ui_up") and active:
		_jump_pressed = true
	
	if Input.is_action_just_pressed("ui_up") and active and coyote_time > 0 and not _was_jumped:
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
		_fall_distance = 0.0
		_actual_state = STATE_MOVE
		_snap_vector = SNAP_DIRECTION*SNAP_LENGHT


func calculate_fall_distance() -> void:
	if _velocity.y > 0 and not _first_fall:
		_initial_fall_pos = self.global_position.y
		_first_fall = true
	
	elif _velocity.y > 0 and _first_fall:
		_fall_distance = (self.global_position.y - _initial_fall_pos)
	
	else:
		_first_fall = false
		_fall_distance = 0.0


var flip_time = 0.1
func move_state(delta):
	flip_nodes()
	movement(_ground_accel, _ground_turn_accel, ground_max_velocity)
		
	if _direction == 0.0:
		flip_time -= delta
		if flip_time < 0:
			_actual_state = STATE_STAND
	
	else:
		flip_time = 0.1
	
	if Input.is_action_just_pressed("ui_up") and active and is_on_floor():
		jump()
	
	if not is_on_floor():
		_actual_state = STATE_AIR


func _get_direction() -> float:
	if active:
		return sign(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	return 0.0


func jump():
	_snap_vector = Vector2.ZERO
	_velocity.y = -jump_force
	_was_jumped = true


func movement(accel:float, turn_accel:float, max_velocity:float) -> void:
	if _direction != 0.0:
		if _direction == sign(_velocity.x) or is_equal_approx(_velocity.x, 0):
			_velocity.x += accel * _direction
		
		else:
			_velocity.x += turn_accel * _direction
		
		_velocity.x = clamp(_velocity.x, -max_velocity, max_velocity)


func manage_animations():
	pass

func flip_nodes():
	if _direction:
		$Flip.scale.x = _direction

