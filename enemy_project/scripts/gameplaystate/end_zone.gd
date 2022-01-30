extends Area2D

var actor_count = 0
export (PackedScene) var next_level


func _ready():
	self.connect("body_entered", self, "on_actor_enter")
	self.connect("body_exited", self, "on_actor_exited")


func on_actor_enter(body):
	if body is Actor:
		actor_count += 2
		
	if actor_count == 2:
		GameEvents.emit_signal("fadeout")
		yield(get_tree().create_timer(1.3), "timeout")
		get_tree().change_scene_to(next_level)


func on_actor_exited(body):
	if body is Actor:
		actor_count -= 1
