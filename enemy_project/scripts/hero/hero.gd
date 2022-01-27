extends Actor
class_name Hero

onready var animation_playback = $AnimationTree.get("parameters/playback")
onready var jump_sfx = $JumpSound


func _ready():
	$Flip/TorchHitBox.connect("body_entered", self, "torch_action")
	$ShakeCamera.current = active


func manage_animations():
	if _actual_state == STATE_STAND:
		animation_playback.travel("stand")
		$Flip/WalkParticle.emitting = false
		
	elif _actual_state == STATE_MOVE:
		animation_playback.travel("walk")
		$Flip/WalkParticle.emitting = true
	
	elif _actual_state == STATE_AIR:
		if (_velocity.y > 0 and _was_jumped) or (_fall_distance > min_jump_size):
			animation_playback.travel('fall')
		elif _velocity.y < 0 :
			animation_playback.travel('jump')
		
		$Flip/WalkParticle.emitting = false
		
		
	if Input.is_action_pressed("action") && is_on_floor():
		animation_playback.travel("attack")


func jump():
	jump_sfx.play()
	_velocity.y = -jump_force
	_was_jumped = true


func torch_action(body):
	if body.is_in_group("spiderweb"):
		#body.playanimation.....
		body.queue_free()
		GameEvents.emit_signal("call_shake", 0.25)


func _get_direction() -> float:
	if (not animation_playback.get_current_node() == "attack") and active:
		return sign(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	return 0.0


func _input(event):
	if event.is_action_pressed("ui_down"):
		active = not active
		$ShakeCamera.current = active
