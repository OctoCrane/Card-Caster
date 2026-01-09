extends State
class_name ActorFall

@export var actor : Actor

@export var air_move_speed := 10.0

func process_frames(_delta: float):
	if actor.is_on_floor():
		if actor.auto_bhop and Input.is_action_pressed("jump"):
			transition.emit("jump")
		if actor.get_move_dir():
			transition.emit("idle")
		else:
			transition.emit("walk")
	
	

func process_physics(delta: float):
	actor.handle_air_physics(delta, air_move_speed)
	actor.move_and_slide()
