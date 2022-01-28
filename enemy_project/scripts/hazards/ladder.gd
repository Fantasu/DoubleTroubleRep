extends Area2D

class_name Ladder


onready var collision_length = $CollisionShape2D.shape.extents

func _ready():
	$OneWayStatic.global_position.y -= collision_length.y
	self.connect("body_entered", self, "on_body_entered")
	self.connect("body_exited", self, "on_body_exited")


func on_body_entered(body):
	if body.is_in_group("Hero"):
		body._inside_ladder = true
		body._ladder = self


func on_body_exited(body):
	if body.is_in_group("Hero"):
		body._inside_ladder = false

