extends CanvasLayer

var hero_sprite = preload("res://assets/sprites/hud/icons/icon_hero.png")
var villain_sprite = preload("res://assets/sprites/hud/icons/icon_villain.png")

export (NodePath) onready var begin = get_node(begin)
export (NodePath) onready var end = get_node(end)
export (NodePath) onready var target = get_node(target)

onready var map_distance = end.global_position.x - begin.global_position.x 
onready var pos_distance = $Ui/End.global_position.x - $Ui/Begin.global_position.x


func _ready():
	GameEvents.connect("call_bars", self, "hide_or_show")
	if target is Hero:
		$Ui/Icon.texture = hero_sprite
#	elif target is Villain:
#		$Icon.texture = villain_sprite
	$Ui/Icon.global_position = $Ui/Begin.global_position


func _process(delta):
	var target_pos = target.global_position.x - begin.global_position.x 
	var percent = target_pos / map_distance
	$Ui/Icon.global_position.x = $Ui/Begin.global_position.x + percent * pos_distance
	
	if target._direction:
		$Ui/Icon.scale.x = target._direction


func hide_or_show(type):
	match type:
		0:
			$Ui.visible = false
		1:
			$Ui.visible = true
