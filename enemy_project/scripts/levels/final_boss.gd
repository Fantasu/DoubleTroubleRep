extends Node2D


func _ready():
	for child in get_children():
		if child is Actor:
			child.get_node("ShakeCamera").zoom = Vector2(1.15, 1.15)
