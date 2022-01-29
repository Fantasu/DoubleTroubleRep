extends Node2D

signal show_map_ended()

export (float, 0.1, 10) var duration_per_position = 1.5
export (float, 0.1, 10) var return_duration = 2.5

var true_start_position = Vector2.ZERO

export (NodePath) onready var first_target = get_node(first_target)
onready var target_camera = first_target.get_node("ShakeCamera")


func _ready():
	yield(get_tree().current_scene, "ready")
	start_animation(target_camera.get_camera_screen_center())


func start_animation(target_position):
	GameEvents.emit_signal("call_bars", 0)
	$Camera2D.current = true
	get_tree().paused = true
	
	var last_position = target_position
	true_start_position = last_position
	
	#loop the childs positions
	for child in get_children():
		if child is Position2D:
			$Tween.interpolate_property($Camera2D, "global_position", last_position, child.global_position, duration_per_position, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
			$Tween.start()
			yield($Tween, "tween_all_completed")
			last_position = child.global_position


#	#return to origin
	$Tween.interpolate_property($Camera2D, "global_position", last_position, true_start_position, return_duration, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")

	target_camera.current = true
	GameEvents.emit_signal("call_bars", 1)
	self.emit_signal("show_map_ended")
	get_tree().paused = false
