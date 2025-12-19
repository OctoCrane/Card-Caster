extends State
class_name Walk

@export var player : Player

@export_group("Walk Properties")
@export var walk_animation : Animation
@export var walk_speed := 200.0
@export var coyote_time := 1.0

var cooldown := coyote_time

func enter():
	print("Entered: ", name)

func update(delta : float):
	if not player.is_on_floor():
		if cooldown <= 0:
			transitioned.emit(self, "fall")
		else:
			cooldown -= delta
	else:
		cooldown = coyote_time

func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_just_pressed("jump"):
		transitioned.emit(self, "jump")
	else:
		if direction:
			player.velocity.x = direction.x * walk_speed * delta
			player.velocity.z = direction.z * walk_speed * delta
		else:
			transitioned.emit(self, "idle")
