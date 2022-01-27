extends Node

export (NodePath) onready var villain = get_node(villain) as Villain
export (NodePath) onready var hero = get_node(hero) as Hero

onready var v_camera = villain.get_node('ShakeCamera') as Camera2D
onready var h_camera = hero.get_node('ShakeCamera') as Camera2D
var actor


func _ready():
	actor = hero
	h_camera.current = true


func _input(event):
	if event.is_action_pressed("ui_down"):
		if actor == hero:
			var initial_pos = h_camera.global_position
			$Tween.interpolate_property(h_camera, "global_position", \
			h_camera.global_position, v_camera.global_position, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			yield($Tween, "tween_all_completed")
			h_camera.current = false
			v_camera.current = true
			
			h_camera.global_position = initial_pos
			
			actor = villain
		elif actor == villain:
			var initial_pos = v_camera.global_position
			$Tween.interpolate_property(v_camera, "global_position", \
			v_camera.global_position, h_camera.global_position, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			yield($Tween, "tween_all_completed")
			v_camera.current = false
			h_camera.current = true
			
			v_camera.global_position = initial_pos
			
			actor = hero
