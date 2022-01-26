extends Node

export (Array, NodePath) var activate_nodepaths_list
var activate_nodes = []

var torch_list = []
var count = 0

var was_activated = false


func _ready():
	for child in get_children():
		if child is Torch:
			child.connect("state_changed", self, "add_to_counter")
			child.actual_state = 0
			child.update_animation()
			torch_list.append(child)
			
			
	for nodepath in activate_nodepaths_list:
		var node = get_node(nodepath)
		activate_nodes.append(node)


func _process(_delta):
	if count == torch_list.size() && was_activated == false:
		for node in activate_nodes:
			if node.has_method("activate"):
				node.activate()
		was_activated = true
		
		
func add_to_counter():
	count += 1
