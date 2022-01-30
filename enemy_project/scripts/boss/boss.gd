extends Node2D

enum {STATE_IDLE, STATE_HERO_PORSUIT, STATE_DOWN_ATACK, STATE_VULNERABLE, STATE_END}

export(NodePath) onready var hero = get_node(hero)
export(NodePath) onready var villain = get_node(villain)

var actual_state = STATE_IDLE
export (float) var hero_porsuit_atack_count = 1
export (float) var vulnerable_atack_count = 1
export (float) var idle_timer = 5.0
export (float) var porsuit_atack_timer := 3.0
export (float) var down_atack_timer := 2.8
export (float) var vulnerable_timer = 7.0
export (float, 0, 1) var speed_increase = 0.2 #percent
export (float, 0, 1) var porsuit_timer_increase = 0.2 #seconds


var _children := []
var _child : BossHand
var _c_size 
var _down_count = 0
var _vulnerable = false
var ended = false

onready var _default_hero_porsuit_atack_count = hero_porsuit_atack_count
onready var _default_vulnerable_timer = vulnerable_timer
onready var _default_idle_timer = idle_timer
onready var _default_vulnerable_count = vulnerable_atack_count
onready var _default_down_timer = down_atack_timer
onready var _default_porsuit_timer = porsuit_atack_timer
onready var random_list = [hero, hero, hero, villain, villain]
onready var ran_list_size = random_list.size()


func _ready():
	randomize()
	for _child in self.get_children():
		if _child is BossHand:
			_children.append(_child)
	_c_size = _children.size()


func _physics_process(delta):
	
	
	match actual_state:
		STATE_IDLE:
			if all_chegou():
				idle_timer -= delta
			
			if idle_timer < 0:
				
				if vulnerable_atack_count <= 0:
					idle_timer = _default_idle_timer
					_vulnerable = false
					vulnerable_atack_count = _default_vulnerable_count
					actual_state = STATE_VULNERABLE
					return
				
				var atack_states = [STATE_IDLE, STATE_HERO_PORSUIT, STATE_DOWN_ATACK]
				var new_state = randi() % atack_states.size()
				if new_state == actual_state or (_c_size == 1 and new_state == STATE_DOWN_ATACK) or new_state == STATE_DOWN_ATACK:
					return
				idle_timer = _default_idle_timer
				if new_state == STATE_HERO_PORSUIT:
					hero_porsuit_atack_count = _default_hero_porsuit_atack_count
					porsuit_atack_timer = _default_porsuit_timer
				vulnerable_atack_count -= 1
				actual_state = new_state
		
		
		STATE_HERO_PORSUIT:
			if _c_size != 1:
				porsuit_atack_timer -= delta
			
			elif _c_size == 1:
				var rand = random_child()
				if rand.chegou:
					porsuit_atack_timer -= delta
			
			if hero_porsuit_atack_count <= 0 and not all_chegou():
				return
			elif hero_porsuit_atack_count <= 0 and all_chegou():
				actual_state = STATE_IDLE
				return
			if porsuit_atack_timer <= 0:
				var rand = random_child()
				if not rand.chegou or (_c_size > 1 and rand == _child):
					return
				
				_child = rand
				_child.direction_to_target(random_target().global_position + Vector2(0, -8))
				hero_porsuit_atack_count -= 1
				porsuit_atack_timer = _default_porsuit_timer
		
		
		STATE_DOWN_ATACK:
#			if not all_chegou():
#				return
			if _c_size == 0:
				return
			down_atack_timer -= delta
			if down_atack_timer < 0:
				_child = _children[_down_count]
				if not _child.chegou:
					return
				_child.direction_to_target(Vector2(_child.global_position.x, _child.global_position.y + 15))
#				_child.direction_to_target(random_target().global_position + Vector2(0, -8))
				if _down_count < _c_size -1 :
					_down_count += 1
					down_atack_timer = _default_down_timer
				elif _down_count >= _c_size-1:
					down_atack_timer = _default_down_timer
					_down_count = 0
					actual_state = STATE_IDLE
		
		
		STATE_VULNERABLE:
			if _c_size == 0 or _vulnerable:
				if not is_instance_valid(_child):
					actual_state = STATE_IDLE
					return
				if _vulnerable and _child.chegou:
					actual_state = STATE_IDLE
					_child.able_stun(true)
					return
				return
			_child = random_child()
			_child.actual_state = _child.STATE_VULNERABLE
			_child.able_damage(true)
			_child.able_stun(false)
			_child.wait_time = vulnerable_timer
			_child.direction_to_target(Vector2 (_child.global_position.x, $Position2D.global_position.y))
			_vulnerable = true
		
		STATE_END:
			if ended == false:
				GameEvents.emit_signal("call_shake", 1)
				GameEvents.emit_signal("fadeout")
				ended = true
				yield(get_tree().create_timer(3.5), "timeout")
				get_tree().change_scene("res://scenes/levels/credits.tscn")

func random_child():
	if _c_size <= 0:
		return
	return _children[randi() % _c_size] 


func random_target():
	return random_list[randi() % ran_list_size]


func child_died(__child):
	$AnimationPlayer.play("hurt")
	_children.erase(__child)
	_c_size = _children.size()
	if _child == __child:
		_child = random_child()
	if (_c_size + 1) % 2 == 0:
		_default_hero_porsuit_atack_count += 1
	_default_porsuit_timer += porsuit_timer_increase

	for c in _children:
			c.speed += c.speed * speed_increase
	
	if _c_size <= 0:
		actual_state = STATE_END


func all_chegou():
	for c in _children:
		if not c.chegou:
			return false
	return true
