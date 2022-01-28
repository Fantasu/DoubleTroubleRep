extends Actor
class_name Villain


onready var animation_playback = $AnimationTree.get("parameters/playback")
onready var jump_sfx = $JumpSound
var _tile_map : TileMap


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
	if active:
		jump_sfx.play()
		.jump()


func _input(event):
	if event.is_action_pressed("ui_accept"):
		active = not active
		$ShakeCamera.current = active
	
	if event.is_action_pressed("ui_down") and active:
		if not _tile_map:
			get_tile()
		if is_instance_valid(_tile_map):
			for child in $BreakPositions.get_children():
				var tile_pos = _tile_map.world_to_map(child.global_position)
				
				if _tile_map.get_cellv(tile_pos) == 1:
					_tile_map.set_cellv(tile_pos, -1)
	
	if event.is_action_pressed("ui_up") and active:
		$OneWayStatic/CollisionShape2D.disabled = false
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
		$OneWayStatic/CollisionShape2D.disabled = true
		_actual_state = STATE_MOVE
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	
	if not is_on_floor():
		$OneWayStatic/CollisionShape2D.disabled = true
		_actual_state = STATE_AIR


