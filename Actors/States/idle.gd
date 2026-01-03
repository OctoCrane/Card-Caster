extends State
class_name Idle

@export var actor : Actor
@export var ground_friction : float = 0.99

func process_frames(_delta: float):
	if not actor.is_on_floor():
		transition.emit("fall")
	elif actor.get_jump():
		transition.emit("jump")
	elif actor.get_move_dir():
		transition.emit("walk")

func process_physics(delta: float):
	actor.velocity.x = lerp(actor.velocity.x, 0., 1-pow(1-ground_friction, delta))
	actor.velocity.z = lerp(actor.velocity.z, 0., 1-pow(1-ground_friction, delta))
	
	actor.move_and_slide()
