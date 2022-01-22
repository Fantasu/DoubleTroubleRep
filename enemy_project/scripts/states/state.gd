extends Node

class_name State


var previous_state : String
var state_name : String
var statemachine
var actor


func enter(_previous_state : String) -> void:
	previous_state = _previous_state


func physics_update(_delta: float) -> void:
	pass


func update(_delta: float) -> void:
	pass


func unhandled_input(_event : InputEvent) -> void:
	pass


func exit() -> void:
	pass

