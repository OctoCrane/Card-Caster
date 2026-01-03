extends State
class_name Fall

@export var actor : Actor

func process_physics(delta: float):
	if actor.is_on_floor():
		if actor.get_move_dir():
			transition.emit("idle")
		else:
			transition.emit("walk")
	else:
		actor.velocity += actor.get_gravity() * delta
	
	actor.move_and_slide()
