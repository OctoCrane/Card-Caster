extends Node
class_name StateMachine

@export var initial_state : State

var current_state : State

var states : Dictionary = {}

func _ready():
	initial_state.disabled = false
	
	current_state = initial_state
	current_state.enter()
	
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(on_transition)
	
	child_entered_tree.connect(on_child_entered_tree)
	child_exiting_tree.connect(on_child_exiting_tree)

func _process(delta: float) -> void:
	current_state.process_frames(delta)

func _physics_process(delta: float) -> void:
	current_state.process_physics(delta)

func on_transition(new_state_name : StringName):
	var new_state : State = states.get(new_state_name)
	if new_state != null:
		if new_state != current_state and not new_state.disabled:
			current_state.exit()
			current_state = new_state
			current_state.enter()

func on_child_entered_tree(node: Node):
	print("Child entered")
	if node is State:
		states[node.name.to_lower()] = node
		node.transition.connect(on_transition)

func on_child_exiting_tree(node : Node):
	print("Child exited")
	if node is State:
		states.erase(node.name)
