extends KinematicBody2D

class_name BossHand

enum {STATE_ATACK, STATE_VULNERABLE}

export (bool) var is_flipped = false
var actual_state = STATE_ATACK
var speed = 50
var _velocity = Vector2.ZERO
var direction = Vector2.ZERO
var target_pos = Vector2.ZERO
var wait_time = 0.5
var chegou = true
var _first_floor = true
var life = 1
onready var initial_pos = self.global_position
onready var default_wait = wait_time
onready var freq = randi() % 6 + 4
var cos_time = 0.0
export(float) var amplitude = 150
var v_cos = Vector2.ZERO

func _ready():
	randomize()
	$StunArea.connect("body_entered", self, "on_actor_entered")
	able_damage(false)
	if is_flipped:
		self.scale.x = -1
	else:
		self.scale.x = 1


func _physics_process(delta):
	
	match actual_state:
		STATE_ATACK:
			if (int(self.global_position.distance_to(target_pos)) <= 3 and target_pos == initial_pos and not chegou) or (is_on_floor() or is_on_wall()):
				if (is_on_floor() or is_on_wall()) and _first_floor:
					GameEvents.emit_signal("call_shake", 0.35)
					_first_floor = false
					able_stun(false)
				
				if not chegou:
					wait_time -= delta
					direction = Vector2.ZERO
				
				if wait_time < 0:
					if target_pos == initial_pos:
						chegou = true
						_first_floor = true
						wait_time = default_wait
						return
					
					direction = self.global_position.direction_to(initial_pos)
					target_pos = initial_pos
			
			elif chegou:
#				animação normal
				$AnimationPlayer.play("normal")
				able_stun(false)
				cos_time += delta / 2
				v_cos.x = cos(cos_time * freq) * amplitude
				direction = v_cos.normalized()
				initial_pos.x = self.global_position.x
			
			elif not chegou and target_pos != initial_pos:
#				ataque animation
				$AnimationPlayer.play("attack")
				pass
		STATE_VULNERABLE:
#			animação vulneravel
			$AnimationPlayer.play("vulnerable")
			able_stun(false)
			if int(self.global_position.distance_to(target_pos)) <= 3:
				if not chegou:
					wait_time -= delta
					direction = Vector2.ZERO
				
				if wait_time <= 0:
					if target_pos == initial_pos:
						chegou = true
						_first_floor = true
						wait_time = default_wait
						able_damage(false)
						actual_state = STATE_ATACK
						return
					
					direction = self.global_position.direction_to(initial_pos)
					target_pos = initial_pos
	
	_velocity = speed * direction
	
	_velocity = move_and_slide(_velocity, Vector2.UP)


func _input(event):
	if event.is_action_pressed("ui_up"):
		on_damage_taken(self)


func direction_to_target(_target_position:Vector2):
	if _target_position != initial_pos:
		able_stun(true)
	chegou = false
	direction = self.global_position.direction_to(_target_position)
	target_pos = _target_position


func on_actor_entered(body:Actor):
	if not body._actual_state == body.STATE_STUNED:
		able_stun(false)
		GameEvents.emit_signal("call_shake", 0.35)
		body._actual_state = body.STATE_STUNED
		wait_time = 0
		direction = self.global_position.direction_to(initial_pos)
		target_pos = initial_pos
		GameEvents.emit_signal("actor_stuned", body)


func on_damage_taken(body):
#	animação dano tomado
	able_damage(false)
	life -= 1
	wait_time = 0
	GameEvents.emit_signal("call_shake", 0.65)
	body._velocity = Vector2(rand_range(-1, 1), -1).normalized() * rand_range(300, 500)
	if life == 0:
		get_parent().child_died(self)
		queue_free()


func able_damage(_bool:bool) -> void:
	$StaticBody2D/CollisionShape2D.disabled = not _bool


func able_stun(_bool:bool) -> void:
	$StunArea.set_deferred("monitoring", _bool)
