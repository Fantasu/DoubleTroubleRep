extends Actor
class_name Villain


onready var animation_playback = $AnimationTree.get("parameters/playback")
onready var autojump_raycast_1 = $Flip/AutojumpRay1
onready var autojump_raycast_2 = $Flip/AutojumpRay2


func _ready():
	autojump_raycast_1.add_exception(self)
	autojump_raycast_2.add_exception(self)


func move_state(delta):
	flip_nodes()
	movement(_ground_accel, _ground_turn_accel, ground_max_velocity)
		
	if _direction == 0.0:
		_actual_state = STATE_STAND
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		jump()
	
	if not is_on_floor():
		_actual_state = STATE_AIR

	if autojump_raycast_1.is_colliding():
		if autojump_raycast_1.get_collider() is TileMap && autojump_raycast_2.is_colliding() == false:
			jump()


func call_shake(trauma: float):
	GameEvents.emit_signal("call_shake", trauma)
