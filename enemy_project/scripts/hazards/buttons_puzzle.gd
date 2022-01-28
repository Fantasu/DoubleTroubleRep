extends Node

export (Array, NodePath) var activate_nodepaths_list
var activate_nodes = []

var button_list = []
var count = 0

var was_activated = false


func _ready():
	for child in get_children():
		if child is _Button:
			child.connect("activated", self, "add_to_counter")
			child.connect("desactivated", self, "remove_to_counter")
			button_list.append(child)
			
			
	for nodepath in activate_nodepaths_list:
		var node = get_node(nodepath)
		activate_nodes.append(node)

		
func add_to_counter():
	count += 1
	
	if count == button_list.size() && was_activated == false:
		for node in activate_nodes:
			node.activate()
		was_activated = true


func remove_to_counter():
	count -= 1
	
