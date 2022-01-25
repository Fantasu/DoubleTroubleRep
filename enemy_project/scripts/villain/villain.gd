extends Actor
class_name Villain


onready var animation_playback = $AnimationTree.get("parameters/playback")
onready var side_raycast = $Raycasts/SideRaycast

export (bool) var active_camera = false


func _ready():
	$ShakeCamera.current = active_camera


func _physics_process(delta):
	print(_actual_state)


func manage_animations():
	if _actual_state == STATE_STAND:
		animation_playback.travel("stand")
		
		
	elif _actual_state == STATE_MOVE:
		animation_playback.travel("walk")
		
	
	elif _actual_state == STATE_AIR:
		if _velocity.y > 0:
			animation_playback.travel('fall')
		else:
			animation_playback.travel('jump')

		
func call_shake(trauma: float):
	GameEvents.emit_signal("call_shake", trauma)


func destroy_tiles():
	if side_raycast.is_colliding():
		var collider = side_raycast.get_collider()
		if collider is TileMap:
			var tile_pos = collider.world_to_map(side_raycast.get_collision_point())
			collider.set_cellv(tile_pos, -1)
			collider.update_bitmask_region(side_raycast.get_collision_point())
