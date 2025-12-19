extends State
class_name Idle

@export var player : Player

@export_group("Idle Properties")
@export var idle_animation : String

func enter():
	print("Entered: ", name)

func update(_delta : float):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	if Input.is_action_just_pressed("jump"):
		transitioned.emit(self, "jump")
	elif input_dir:
		transitioned.emit(self, "walk")
	
	if not player.is_on_floor():
		transitioned.emit(self, "jump")
