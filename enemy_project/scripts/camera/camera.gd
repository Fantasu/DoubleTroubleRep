extends Camera2D

export (float, 0, 1) var decay = 0.5
export (float) var max_roll = 0.1
export (Vector2) var max_offset = Vector2(90, 80)

var trauma = 0
var trauma_power = 2
var noise_y = 0

onready var noise = OpenSimplexNoise.new()
onready var sfx = $AudioStreamPlayer


func _ready():
	GameEvents.connect("call_shake", self, "add_trauma")
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2


func add_trauma(amount):
	#this will add trauma to the current trauma, the higher more shake that exists.
	trauma = min(trauma + amount, 1.0)
	sfx.pitch_scale = rand_range(0.5, 2.7)
	sfx.play()
	

func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
		
		
func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
