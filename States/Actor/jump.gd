extends State
class_name Jump

@export var player : Player

@export_group("Jump Properties")
@export var jump_animation : Animation
@export var jump_velocity := 4.5
@export var air_friction := 0.01

func enter():
	player.jump()
	print("Entered: ", name)

func update(_delta):
	if player.velocity.y <= 0:
		transitioned.emit(self, "fall")

func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if input_dir:
		player.velocity.x = direction.x * player.airSpeed * delta
		player.velocity.z = direction.z * player.airSpeed * delta
	else:
		player.velocity.x = lerp(player.velocity.x, 0., 1.0 - pow(air_friction, delta))
		player.velocity.z = lerp(player.velocity.z, 0., 1.0 - pow(air_friction, delta))
	
