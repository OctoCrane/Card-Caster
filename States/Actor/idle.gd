extends State
class_name Idle

@export var player : Player

@export_group("Idle Properties")
@export var idle_animation : String

func enter():
	print("Entered: ", name)

func physics_update(delta : float):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	if Input.is_action_just_pressed("jump"):
		transitioned.emit(self, "jump")
	elif input_dir:
		transitioned.emit(self, "walk")
	else:
		player.velocity.x = lerp(player.velocity.x, 0., 1.0 - pow(player.groundFriction, delta))
		player.velocity.z = lerp(player.velocity.z, 0., 1.0 - pow(player.groundFriction,delta))
		
	if not player.is_on_floor():
		transitioned.emit(self, "fall")
