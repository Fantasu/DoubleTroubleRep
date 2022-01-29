extends Node2D

export(int) var activate_count = 1
var actives : int = 0


func activate():
	actives += 1
	if actives == activate_count:
		$AnimationPlayer.play("open")
#  GameEvents.emit_signal("call_shake", 0.2)


func desactivate():
	actives -= 1
	if actives == 0:
		$AnimationPlayer.play("close")
