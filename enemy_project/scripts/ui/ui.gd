extends CanvasLayer

var hero_sprite = preload("res://assets/sprites/hud/icons/icon_hero.png")
var villain_sprite = preload("res://assets/sprites/hud/icons/icon_villain.png")

export (NodePath) onready var begin = get_node(begin)
export (NodePath) onready var end = get_node(end)

onready var map_distance = end.global_position.x - begin.global_position.x 
onready var pos_distance = $Ui/End.global_position.x - $Ui/Begin.global_position.x

export (NodePath) onready var target = get_node(target)


func _ready():
	$Ui/Icon.visible = false
	$Ui/Icon.global_position = $Ui/Begin.global_position


func _process(_delta):
	if target is Hero:
		$Ui/Icon.texture = hero_sprite
		$Ui/Icon.visible = true
		
	elif target is Villain:
		$Ui/Icon.texture = villain_sprite
		$Ui/Icon.visible = true
		
	var target_pos = target.global_position.x - begin.global_position.x 
	var percent = target_pos / map_distance
	$Ui/Icon.global_position.x = $Ui/Begin.global_position.x + percent * pos_distance
	
	if target is Actor:
		if target._direction:
			$Ui/Icon.scale.x = target._direction

