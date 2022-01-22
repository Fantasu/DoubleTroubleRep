extends Node

class_name StateMachine

var states : Dictionary
var state : Array
var previous_state : String

export(String) var actual_state
export(bool) var enabled := true setget set_enable


func _ready():
	yield(owner, 'ready')
	set_enable(enabled)
	for s in self.get_children():
		s.statemachine = self
		s.actor = owner
		states[s.state_name] = s
	states[actual_state].enter('')


func _process(delta):
	states[actual_state].update(delta)
	
	
func _physics_process(delta):
	states[actual_state].physics_update(delta)


func _unhandled_input(event):
	states[actual_state].unhandled_input(event)


func change_state(_new_state:String) -> void:
	previous_state = actual_state
	actual_state = _new_state
	states[previous_state].exit()
	states[actual_state].enter(previous_state)


func set_enable(new_value : bool) -> void:
	enabled = new_value
	set_physics_process(enabled)
	set_process_unhandled_input(enabled)

