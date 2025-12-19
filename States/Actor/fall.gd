extends State
class_name Fall

@export var player : Player

@export_group("Fall Properties")
@export var fall_animation : Animation
@export var air_friction := 0.01
@export var jump_buffer := 0.07

var cooldown := 0.0

func enter():
	print("Entered: ", name)

func update(delta):
	if Input.is_action_just_pressed("jump"):
		cooldown = jump_buffer
	
	cooldown -= delta

func physics_update(delta: float) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if not player.is_on_floor():
		if input_dir:
			player.velocity.x = direction.x * player.airSpeed * delta
			player.velocity.z = direction.z * player.airSpeed * delta
		else:
			player.velocity.x = lerp(player.velocity.x, 0.0, 1.0 - pow(air_friction, delta))
			player.velocity.z = lerp(player.velocity.z, 0.0, 1.0 - pow(air_friction,delta))
	else:
		if cooldown > 0:
			transitioned.emit(self, "jump")
			cooldown = 0
		elif input_dir:
			transitioned.emit(self,"walk")
		else:
			transitioned.emit(self,"idle")
