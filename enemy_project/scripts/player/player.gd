extends KinematicBody2D

const TILE_SIZE = 16

export (float) var max_horizontal_ground_velocity := 8.0 * TILE_SIZE
export (float) var ground_accel_time := 0.25
export (float) var ground_fric_time := 0.20
export (float) var ground_turn_time := 0.25

export (float) var max_horizontal_air_velocity := 8.75 * TILE_SIZE
export (float) var air_accel_time := 0.30
export (float) var air_fric_time := 0.25 
export (float) var air_fric_time_no_walk := 1.25 
export (float) var air_turn_time := 0.4

export (float) var time_to_jump_rise := 0.95
export (float) var time_to_jump_fall := 0.65

export (float) var jump_buffering_timer := 0.10 #perfect
export (float) var coyote_limit := 0.10 #perfect

var max_jump_height := 2.4 * TILE_SIZE
var min_jump_height := 0.6 * TILE_SIZE

var _direction := 0.0
var _velocity := Vector2.ZERO
var _coyote_timer := 0.0
var _was_jumped := false
var _was_buffering_pressed := false

onready var _min_time_to_rise : float = (min_jump_height * time_to_jump_rise)/max_jump_height
onready var _gravity_rising : float = 2 * max_jump_height/pow((time_to_jump_rise/2), 2)
onready var _gravity_falling : float = 2 * max_jump_height/pow((time_to_jump_fall/2), 2)
onready var _default_buffering_timer : float = jump_buffering_timer
onready var _max_jump_velocity : float = sqrt(2 * _gravity_rising * max_jump_height)
onready var _min_jump_velocity : float = sqrt(2 * _gravity_rising * min_jump_height)


func jump() -> void:
	_velocity.y = _max_jump_velocity * -1
	_coyote_timer = 0
	_was_jumped = true


func get_direction():
	return sign(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))


