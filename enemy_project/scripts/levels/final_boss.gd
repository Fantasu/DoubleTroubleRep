extends Node2D


func _ready():
	$Boss.connect("death", self, "start_anim")
	for child in get_children():
		if child is Actor:
			child.get_node("ShakeCamera").zoom = Vector2(1.15, 1.15)


func start_anim():
	$AnimationPlayer.play("death")


func call_shake():
	GameEvents.emit_signal("call_shake", 0.75)


func create_credits():
	$FadeAnimation/Fade/AnimationPlayer.play("fadeout")
	yield(get_tree().create_timer(1),"timeout")
	get_tree().change_scene("res://scenes/levels/credits.tscn")
