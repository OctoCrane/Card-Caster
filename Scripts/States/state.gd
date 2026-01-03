extends Node
class_name State

@export var disabled := false

signal transition(new_state_name : StringName)

func enter():
	#print("Entered State: ", name)
	pass

func exit():
	#print("Exited State: ", name)
	pass

func process_frames(_delta: float):
	pass

func process_physics(_delta: float):
	pass
