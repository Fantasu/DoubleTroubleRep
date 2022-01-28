extends Actor
class_name Villain


onready var animation_playback = $AnimationTree.get("parameters/playback")
onready var jump_sfx = $JumpSound
var _tile_map : TileMap

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
			
			
	if Input.is_action_pressed("ui_down") && active == true:
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


func destroy_tiles():
	if not _tile_map:
		get_tile()
	if is_instance_valid(_tile_map):
		for child in $BreakPositions.get_children():
			var tile_pos = _tile_map.world_to_map(child.global_position)
			if _tile_map.get_cellv(tile_pos) == 1:
				_tile_map.set_cellv(tile_pos, -1)
				_tile_map.update_bitmask_area(tile_pos)
					

func _input(event):
	if event.is_action_pressed("ui_up") and active:
#		$OneWayStatic/CollisionShape2D.disabled = false
		_actual_state = STATE_PLATFORM


func get_tile():
	if $BreakTileRay.is_colliding():
		var collider = $BreakTileRay.get_collider()
		if collider is TileMap:
			_tile_map = collider
			$BreakTileRay.enabled = false


func platform_state(delta):
	if not _inside_wind:
		_velocity.x = max(abs(_velocity.x) - _ground_fric, 0.0) * sign(_velocity.x)
	
	_velocity.x = clamp(_velocity.x, -ground_max_velocity, ground_max_velocity)
	
	if _direction != 0:
#		$OneWayStatic/CollisionShape2D.disabled = true
		_actual_state = STATE_MOVE
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	
	if not is_on_floor():
#		$OneWayStatic/CollisionShape2D.disabled = true
		_actual_state = STATE_AIR


func setting_active_property(new_value):
	active = new_value
	$ShakeCamera.current = active
