extends CanvasLayer

var hero_sprite = preload("res://assets/sprites/hud/icons/icon_hero.png")
var villain_sprite = preload("res://assets/sprites/hud/icons/icon_villain.png")

export (NodePath) onready var begin = get_node(begin)
export (NodePath) onready var end = get_node(end)

onready var map_distance = end.global_position.x - begin.global_position.x 
onready var pos_distance = $Ui/End.global_position.x - $Ui/Begin.global_position.x

export (NodePath) onready var hero = get_node(hero)
export (NodePath) onready var villain = get_node(villain)


func _ready():
	$Ui/Icon.visible = false
	$Ui/Icon.global_position = $Ui/Begin.global_position
	$Ui/Icon2.global_position = $Ui/Begin.global_position
	
	$Ui/Icon.texture = hero_sprite
	$Ui/Icon.visible = true
	$Ui/Icon2.texture = villain_sprite
	$Ui/Icon2.visible = true


func _process(_delta):
	
	var hero_pos = hero.global_position.x - begin.global_position.x 
	var hero_pos2 = villain.global_position.x - begin.global_position.x 
	var percent = hero_pos / map_distance
	var percent2 = hero_pos2 / map_distance
	$Ui/Icon.global_position.x = $Ui/Begin.global_position.x + percent * pos_distance
	$Ui/Icon2.global_position.x = $Ui/Begin.global_position.x + percent2 * pos_distance
	
	if hero._direction:
		$Ui/Icon.scale.x = hero._direction
	if villain._direction:
		$Ui/Icon2.scale.x = villain._direction

