extends Actor
class_name Villain


onready var animation_playback = $AnimationTree.get("parameters/playback")
onready var side_raycast = $Raycasts/SideRaycast
onready var jump_sfx = $JumpSound


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


func call_shake(trauma: float):
	GameEvents.emit_signal("call_shake", trauma)


func jump():
	jump_sfx.play()
	_velocity.y = -jump_force
	_was_jumped = true


func _input(event):
	if event.is_action_pressed("ui_accept"):
		active = not active
		$ShakeCamera.current = active

