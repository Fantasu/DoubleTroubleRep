extends Node

class_name ActorManager

export (NodePath) onready var hero = get_node(hero) as Hero
export (NodePath) onready var villain = get_node(villain) as Villain

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
			change_to_villain()
		
		elif _actual_actor is Villain:
			change_to_hero()
		
		GameEvents.emit_signal("call_shake", 0.25)


func change_to_villain() -> void:
	_actual_actor = villain
	hero.active = false
	villain.active = true


func change_to_hero() -> void:
	_actual_actor = hero
	villain.active = false
	hero.active = true

