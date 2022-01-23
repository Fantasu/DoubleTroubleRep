extends Node2D

func _input(event):
	if event.is_action_pressed("ui_down"):
		GameEvents.emit_signal("call_shake", 0.3)
