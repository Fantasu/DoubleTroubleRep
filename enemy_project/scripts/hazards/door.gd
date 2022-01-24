extends Node2D


func _ready():
	pass


func activate():
	$AnimationPlayer.play("open")
