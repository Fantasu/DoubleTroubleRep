extends Control

export (PackedScene) onready var first_level


func _input(event):
	if event.is_action_pressed("action"):
		go_to_first_level()


func go_to_first_level():
	$AnimationPlayer.play("fade")


func change_scene():
	get_tree().change_scene_to(first_level)
