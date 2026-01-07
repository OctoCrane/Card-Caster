extends State
class_name ActorJump

@export var actor : Actor
@export var jump_velocity := 5.0

func enter():
	actor.velocity.y = jump_velocity

func process_frames(_delta: float):
	if actor.is_on_floor():
		if actor.get_move_input_dir():
			transition.emit("walk")
		else:
			transition.emit("idle")
	else:
		if actor.velocity.y < 0:
			transition.emit("fall")

func process_physics(delta: float):
	actor.velocity += actor.get_gravity() * delta
	
	actor.move_and_slide()
