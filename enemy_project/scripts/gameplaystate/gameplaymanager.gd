extends Node

enum {SHOW_MAP, VILLAIN_TURN, HERO_TURN}
var actual_game_state = SHOW_MAP

onready var villain = preload("res://scenes/villain/villain.tscn")
onready var hero = preload("res://scenes/hero/hero.tscn")

export (NodePath) onready var hud = get_node(hud)
export (NodePath) onready var camera_anim = get_node(camera_anim)

export (NodePath) onready var start_position = get_node(start_position) as Position2D
export (NodePath) onready var end_zone = get_node(end_zone) as Area2D

export (PackedScene) var next_stage


var current_actor = null
var current_hero = null
var current_villain = null


func _ready():
	yield(get_tree().current_scene, "ready")
	end_zone.connect("body_entered", self, "on_end_zone_reached")
	
	start_villain_turn()
	
	if actual_game_state == SHOW_MAP:
		camera_anim.start_animation(current_villain.global_position)
		yield(camera_anim, "show_map_ended")
		update_actor(current_villain)
		actual_game_state = VILLAIN_TURN
		

func start_hero_turn():
	var h = hero.instance()
	get_tree().current_scene.call_deferred("add_child", h)
	h.global_position = start_position.global_position
	current_hero = h
	
	
func start_villain_turn():
	var v = villain.instance()
	get_tree().current_scene.add_child(v)
	v.global_position = start_position.global_position
	current_villain = v


func update_actor(actor):
	hud.target = actor
	current_actor = actor
	current_actor.get_node("ShakeCamera").current = true
	
	
func on_end_zone_reached(body):
	if body is Villain:
		actual_game_state = HERO_TURN
		
		start_hero_turn()
		camera_anim.return_to_origin(current_actor.get_node("ShakeCamera").get_camera_screen_center())
		yield(camera_anim, "show_map_ended")
		
		current_actor.queue_free()
		update_actor(current_hero)
		
	if body is Hero:
		get_tree().change_scene_to(next_stage)
		#aqui tem depedencia cyclica e godot chora
#		get_tree().change_scene("res://scenes/master.tscn")
		pass
