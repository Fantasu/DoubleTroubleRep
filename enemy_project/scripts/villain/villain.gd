extends Actor
class_name Villain


onready var animation_playback = $AnimationTree.get("parameters/playback")
onready var side_raycast = $Raycasts/SideRaycast
onready var jump_sfx = $JumpSound

var forbidden_animations = ["down_attack", "side_attack"]


func _ready():
	$ShakeCamera.current = active


func manage_animations():
	if _actual_state == STATE_STAND:
		animation_playback.travel("stand")
		
		
	elif _actual_state == STATE_MOVE:
		animation_playback.travel("walk")
		
	
	elif _actual_state == STATE_AIR:
		if (_velocity.y > 0 and _was_jumped) or (_fall_distance > min_jump_size):
			animation_playback.travel('fall')
		elif _velocity.y < 0 :
			animation_playback.travel('jump')
			
			
	if Input.is_action_pressed("action") && is_on_floor() && active == true:
		animation_playback.travel("down_attack")


func _get_direction() -> float:
	if (not animation_playback.get_current_node() in forbidden_animations) and active:
		return sign(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	return 0.0


func call_shake(trauma: float):
	GameEvents.emit_signal("call_shake", trauma)


func jump():
	if (not animation_playback.get_current_node() in forbidden_animations) and active:
		jump_sfx.play()
		_velocity.y = -jump_force
		_was_jumped = true


func _input(_event):
	pass
	

func setting_active_property(new_value):
	active = new_value
	$ShakeCamera.current = active
