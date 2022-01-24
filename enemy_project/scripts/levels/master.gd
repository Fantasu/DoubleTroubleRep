extends Node2D


func _ready():
#	$CameraAnimation.start_animation()
	pass


func _input(event):
	if event.is_action_pressed("ui_down"):
		GameEvents.emit_signal("call_shake", 0.3)
		
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("ui_home"):
		GameEvents.emit_signal("call_bars", 1)
	
	if event.is_action_pressed("ui_page_up"):
		$CameraAnimation.start_animation()
