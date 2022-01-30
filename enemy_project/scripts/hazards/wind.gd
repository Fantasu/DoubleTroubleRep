extends Area2D

export(String, 'left', 'right', 'up', 'down') var direction = 'up'
export(float) var villain_strength := 35.0
export(float) var hero_strength := 20.0

var _dict_direc := {
	'left' : Vector2.LEFT,
	'right' : Vector2.RIGHT,
	'up' : Vector2.UP,
	'down' : Vector2.DOWN
}

var _bodies := []


func _ready():
	self.connect("body_entered", self, "on_body_entered")
	self.connect("body_exited", self, "on_body_exited")
	$WindPart.emitting = true
	$WindPart.rotation = _dict_direc[direction].angle()
	$AudioStreamPlayer2D.play()


func _physics_process(_delta):
	if not _bodies.empty():
		for body in _bodies:
			if body is Villain:
				body._velocity += _dict_direc[direction] * villain_strength
			if body is Hero:
				body._velocity += _dict_direc[direction] * hero_strength
 

func on_body_entered(body):
	if body is Actor:
		if direction == 'left' or direction == 'right':
			body._inside_wind = true
		elif direction == 'up' or direction == 'down':
			body.gravity = 0
		_bodies.append(body)


func on_body_exited(body):
	if _bodies.has(body):
		if direction == 'left' or direction == 'right':
			body._inside_wind = false
		elif direction == 'up' or direction == 'down':
			body.gravity = body._default_gravity
		_bodies.erase(body)

