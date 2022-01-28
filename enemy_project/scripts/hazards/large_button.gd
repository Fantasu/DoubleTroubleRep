extends Area2D

export (Array, NodePath) var activate_nodepaths_list
export (String, 'press_stand', 'press_release')var mode = 'press_stand'
var _actors_count = 2
var _bodies := []
var _activate_nodes = []


func _ready():
	self.connect("body_entered", self, "on_body_entered")
	self.connect("body_exited", self, "on_body_exited")
	
	for nodepath in activate_nodepaths_list:
		var node = get_node(nodepath)
		_activate_nodes.append(node)


func on_body_entered(body):
	if body is Actor:
		_bodies.append(body)
		if _bodies.size() == _actors_count:
			activate()


func on_body_exited(body):
	if body is Actor and _bodies.has(body):
		_bodies.erase(body)
		if mode == 'press_release':
			desactivate()


func activate():
#	press animation
	for node in _activate_nodes:
		node.activate()


func desactivate():
#	release animation
	for node in _activate_nodes:
		node.desactivate()

