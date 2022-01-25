extends Actor
class_name Hero

onready var animation_playback = $AnimationTree.get("parameters/playback")

export (bool) var active_camera = false


func _ready():
	$ShakeCamera.current = active_camera

	
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
