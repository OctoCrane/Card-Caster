extends State
class_name ActorWalk

@export var actor : Actor

@export var walk_speed := 250.0

func process_frames(_delta: float):
	if actor.is_on_floor():
		if not actor.get_move_input_dir():
			transition.emit("idle")
		elif actor.get_jump():
			transition.emit("jump")
	else:
		transition.emit("fall")

func process_physics(delta: float):
	var direction : Vector3 = actor.get_move_dir()
	
	if direction:
		actor.handle_move(delta, walk_speed, direction)
	
	actor.move_and_slide()
