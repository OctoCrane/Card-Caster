extends State
class_name Jump

@export var player : Player

@export_group("Jump Properties")
@export var jump_animation : Animation
@export var jump_velocity := 4.5
@export var air_speed := 170.0
@export var jump_buffer := 0.03

var cooldown := 0.0

func enter():
	player.velocity.y = jump_velocity
	print("Entered: ", name)

func update(delta):
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#if player.is_on_floor():
			#transitioned.emit(self, "walk")
		#else:
			#player.velocity.x = direction.x * air_speed * delta
			#player.velocity.z = direction.z * air_speed * delta
	#else:
		#transitioned.emit(self, "idle")
		#player.velocity.x = move_toward(player.velocity.x, 0, air_speed)
		#player.velocity.z = move_toward(player.velocity.z, 0, air_speed)
	
	if Input.is_action_just_pressed("jump"):
		cooldown = jump_buffer
	
	if not player.is_on_floor():
		if input_dir:
			player.velocity.x = direction.x * air_speed * delta
			player.velocity.z = direction.z * air_speed * delta
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, air_speed)
			player.velocity.z = move_toward(player.velocity.z, 0, air_speed)
	else:
		if cooldown > 0:
			player.velocity.y = jump_velocity
			cooldown = 0
		elif input_dir:
			transitioned.emit(self,"walk")
		else:
			transitioned.emit(self,"idle")
	
	if cooldown > 0:
		cooldown -= delta
	else:
		cooldown = 0
