extends State
class_name ActorWalk

@export var actor : Actor

@export var walk_speed := 8.0

func process_frames(_delta: float):
	if actor.is_on_floor():
		if not actor.get_move_input_dir():
			transition.emit("idle")
		elif actor.get_jump():
			transition.emit("jump")
	else:
		transition.emit("fall")

func process_physics(delta: float):
	actor.handle_ground_physics(delta, walk_speed)
	
	actor.move_and_slide()
