extends Area2D
class_name _Button

export (Array, NodePath) var activate_nodepaths_list
var activate_nodes = []
var was_activated = false

func _ready():
	self.connect("body_entered", self, "on_body_press")
	self.connect("body_exited", self, "on_body_exited")
	for nodepath in activate_nodepaths_list:
		var node = get_node(nodepath)
		activate_nodes.append(node)


func on_body_press(body):
	if body is Villain && was_activated == false:
		$AnimationPlayer.play("pressbutton")
		for node in activate_nodes:
			if node.has_method("activate"):
				node.activate()
		was_activated = true
		
	if body is Hero && was_activated == false:
		$AnimationPlayer.play("semipress")
		
		
func on_body_exited(body):
	if body is Hero && was_activated == false:
		$AnimationPlayer.play("RESET")
