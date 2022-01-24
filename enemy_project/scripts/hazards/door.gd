extends Node2D


func activate():
	$AnimationPlayer.play("open")
	GameEvents.emit_signal("call_shake", 0.2)
	
	
func call_shake(trauma):
	print(trauma)
