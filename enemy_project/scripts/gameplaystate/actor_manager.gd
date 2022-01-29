extends Node

export (NodePath) onready var hero = get_node(hero)
export (NodePath) onready var villain = get_node(villain)


onready var hero_cam = hero.get_node("ShakeCamera")
onready var villain_cam = villain.get_node("ShakeCamera")

var _actual_actor : Actor


func _ready():
	_actual_actor = hero
	hero.active = true
	villain.active = false


func _input(event):
	if event.is_action_pressed("change_character"):

		if _actual_actor is Hero:
			_actual_actor = villain
			hero.active = false
			villain.active = true
		
		elif _actual_actor is Villain:
			_actual_actor = hero
			villain.active = false
			hero.active = true
			
		GameEvents.emit_signal("call_shake", 0.25)
