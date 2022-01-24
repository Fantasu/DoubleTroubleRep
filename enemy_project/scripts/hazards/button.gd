extends Area2D
class_name _Button

export (Array, NodePath) var activate_nodepaths_list
var activate_nodes = []


func _ready():
	self.connect("body_entered", self, "on_body_press")
	for nodepath in activate_nodepaths_list:
		var node = get_node(nodepath)
		activate_nodes.append(node)


func on_body_press(body):
#	if body is Villain:
#		$AnimationPlayer.play("pressbutton")
		for node in activate_nodes:
			if node.has_method("activate"):
				node.activate()
