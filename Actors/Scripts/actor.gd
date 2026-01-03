extends CharacterBody3D
class_name Actor

# Allows logic to interface with physics entities

func get_move_input_dir() -> Vector2:
	return Vector2.ZERO

func get_move_dir() -> Vector3:
	var input_dir = get_move_input_dir()
	return (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

func get_jump(_held := false) -> bool:
	return false

func get_attack(_held := false) -> bool:
	return false

func jump(jump_force : float):
	velocity.y = jump_force

func handle_friction(delta : float, friction : float):
	velocity.x = lerp(velocity.x, 0, 1 - pow(friction, delta))

func handle_move(delta : float, speed : float, direction : Vector3):
	velocity.x = direction.x * speed * delta
	velocity.z = direction.z * speed * delta
