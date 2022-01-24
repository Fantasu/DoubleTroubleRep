extends Node2D

export (NodePath) onready var true_camera = get_node(true_camera)
export (float, 0.1, 10) var duration_per_position = 1.5
export (float, 0.1, 10) var return_duration = 2.5


func start_animation():
	GameEvents.emit_signal("call_bars", 0)
	$Camera2D.current = true
	get_tree().paused = true
	
	var last_position = true_camera.get_camera_screen_center()
	
	#loop the childs positions
	for child in get_children():
		if child is Position2D:
			$Tween.interpolate_property($Camera2D, "global_position", last_position, child.global_position, duration_per_position, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
			$Tween.start()
			yield($Tween, "tween_all_completed")
			last_position = child.global_position
	
	
#	#return to origin
	$Tween.interpolate_property($Camera2D, "global_position", last_position, true_camera.get_camera_screen_center(), return_duration, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	GameEvents.emit_signal("call_bars", 1)
	true_camera.current = true
	get_tree().paused = false
