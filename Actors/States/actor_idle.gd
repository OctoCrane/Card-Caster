extends State
class_name ActorIdle

@export var actor : Actor

func process_frames(_delta: float):
	if not actor.is_on_floor():
		transition.emit("fall")
	elif actor.get_jump():
		transition.emit("jump")
	elif actor.get_move_dir():
		transition.emit("walk")

func process_physics(delta: float):
	actor.handle_ground_physics(delta, 0)
	
	actor.move_and_slide()
