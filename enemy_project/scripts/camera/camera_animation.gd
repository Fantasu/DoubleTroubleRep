extends Node2D

export (NodePath) onready var initial_node = get_node(initial_node)
export (NodePath) onready var final_node = get_node(final_node)
export (NodePath) onready var true_camera = get_node(true_camera)


func _ready():
	pass


func start_animation():
	get_tree().paused = true
	GameEvents.emit_signal("call_bars", 0)
	$Camera2D.current = true
	
	$Tween.interpolate_property($Camera2D, "global_position", true_camera.global_position, final_node.global_position, 4.5, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	
	$Tween.interpolate_property($Camera2D, "global_position", final_node.global_position, true_camera.global_position, 2.5, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	
	true_camera.current = true
	get_tree().paused = false
	GameEvents.emit_signal("call_bars", 1)
