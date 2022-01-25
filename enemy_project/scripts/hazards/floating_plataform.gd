extends StaticBody2D


func _ready():
	$Area2D.connect("body_exited", self, 'on_body_exited_break')
	pass


func on_body_exited_break(body):
	if body is Villain or body is Hero:
		self.queue_free()
