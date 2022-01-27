extends Camera2D

export (float, 0, 1) var decay = 0.5
export (float) var max_roll = 0.1
export (Vector2) var max_offset = Vector2(90, 80)

export (NodePath) onready var target_node = get_node(target_node)

var trauma = 0
var trauma_power = 2
var noise_y = 0

var _target

var _facing = 0
var look_ahead = 0.2

onready var prev_camera_position = get_camera_position()
onready var noise = OpenSimplexNoise.new()
onready var sfx = $AudioStreamPlayer


func _ready():
	GameEvents.connect("call_shake", self, "add_trauma")
	target_node.connect("pisando_atualizado", self, "atualizou_pisando")
	GameEvents.connect("cam_changed", self, "cam_changed")
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2


func add_trauma(amount):
	#this will add trauma to the current trauma, the higher more shake that exists.
	trauma = min(trauma + amount, 1.0)
	sfx.pitch_scale = rand_range(0.7, 2.2)
	sfx.play()
	

func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
	
	check_facing()
	prev_camera_position = get_camera_position()


func check_facing():
	var new_facing = sign(get_camera_position().x - prev_camera_position.x)
	if new_facing != 0 and _facing != new_facing:
		_facing = new_facing
		var target_offset = get_viewport_rect().size.x * _facing * look_ahead
		
		position.x = target_offset


func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)


func atualizou_pisando(_ta_pisando):
	drag_margin_v_enabled = not _ta_pisando


func cam_changed(start_pos):
	if owner.active:
		var final_pos = self.global_position
		self.global_position = start_pos
		self.current = owner.active
		$Tween.interpolate_property(self, 'global_position', start_pos, final_pos, 2, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
		$Tween.start()
		yield($Tween, "tween_all_completed")

