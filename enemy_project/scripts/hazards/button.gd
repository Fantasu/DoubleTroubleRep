extends Area2D
class_name _Button


export (Array, NodePath) var activate_nodepaths_list
var activate_nodes = []
var was_activated = false
export(String, 'Villain', 'Hero') var target = 'Villain'
export(String, 'press_stand', 'press_release') var mode = 'press_stand'


func _ready():
	self.connect("body_entered", self, "on_body_press")
	self.connect("body_exited", self, "on_body_exited")
	for nodepath in activate_nodepaths_list:
		var node = get_node(nodepath)
		activate_nodes.append(node)


func on_body_press(body):
	if body.name == target and was_activated == false:
		activate()
	
	if body.name != target and was_activated == false:
		semi_activate()


func on_body_exited(body):
	if body.name != target and was_activated == false:
		$AnimationPlayer.play("RESET")
	
	if body.name == target and mode == 'press_release':
		desactivate()


func activate():
	$AnimationPlayer.play("pressbutton")
	for node in activate_nodes:
		if node.has_method("activate"):
			node.activate()
	was_activated = true


func semi_activate():
	$AnimationPlayer.play("semipress")


func desactivate():
	$AnimationPlayer.play("RESET")
	was_activated = false
	for node in activate_nodes:
		if node.has_method("desactivate"):
			node.desactivate()
