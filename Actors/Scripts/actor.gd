extends CharacterBody3D
class_name Actor

@export var status : Status

@export var auto_bhop := true

@export var ground_accel := 14.0
@export var ground_decel := 10.0
@export var ground_friction := 6.0

@export var air_speed := 7.0
@export var air_accel := 10.0
@export var air_cap := 0.85

func _ready() -> void:
	status.is_dead.connect(on_is_dead)
	status.took_damage.connect(on_took_damage)

func get_move_input_dir() -> Vector2:
	return Vector2.ZERO

func get_move_dir() -> Vector3:
	var input_dir = get_move_input_dir()
	return (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

func get_look_dir() -> Vector3:
	var look_dir = transform.basis * Vector3(0.0,0.0,1.0)
	return look_dir

func get_global_look_dir() -> Vector3:
	var look_dir = global_transform.basis * Vector3(0.,0.,1.)
	return look_dir

func get_jump(_held := false) -> bool:
	return false

func get_attack(_held := false) -> bool:
	return false

func clip_velocity(normal : Vector3, overbounce : float):
	var backoff := velocity.dot(normal) * overbounce
	
	if backoff >= 0: return
	
	var change := normal * backoff
	velocity -= change 
	
	var adjust = velocity.dot(normal)
	if adjust < 0.0:
		velocity -= normal * adjust

func is_surface_to_steep(normal:Vector3) -> bool:
	var max_slope_ang_dot = Vector3.UP.rotated( Vector3(1,0,0), floor_max_angle ).dot(Vector3.UP)
	if normal.dot(Vector3.UP) < max_slope_ang_dot:
		return true
	return false

func handle_ground_physics(delta:float,walk_speed:float):
	#Similar to air movement
	var wish_dir = get_move_dir()
	var cur_speed_in_wish_dir = velocity.dot(wish_dir)
	var add_speed_till_cap = walk_speed - cur_speed_in_wish_dir
	if add_speed_till_cap > 0:
		var accel_speed = ground_accel * delta * walk_speed
		accel_speed = min(accel_speed, add_speed_till_cap)
		velocity += accel_speed * wish_dir
	
	#Apply Friction
	var control = max(velocity.length(), ground_decel)
	var drop = control * ground_friction * delta
	var new_speed = max(velocity.length() - drop, 0.0)
	if velocity.length() > 0:
		new_speed /= velocity.length()
	velocity *= new_speed

func handle_air_physics(delta:float,air_move_speed:float):
	velocity += get_gravity() * delta
	
	#Counter-Strike Source Movement
	var cur_speed_in_wish_dir = velocity.dot(get_move_dir())
	var capped_speed = min(air_move_speed, air_cap)
	var add_speed_till_cap = capped_speed - cur_speed_in_wish_dir
	
	if add_speed_till_cap > 0:
		var accel_speed = air_accel * air_move_speed * delta
		accel_speed = min(accel_speed, add_speed_till_cap)
		velocity += accel_speed * get_move_dir()
	
	if is_on_wall():
		if is_surface_to_steep(get_wall_normal()):
			motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
		else:
			motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
		
		clip_velocity(get_wall_normal(), 1.0)
	elif is_on_floor() and get_real_velocity().y > 6:
		clip_velocity(get_floor_normal(), 1.0)

func damage(dm: int):
	status.health -= dm
	if status.health <= 0:
		queue_free()

func on_is_dead():
	queue_free()

func on_took_damage(dm : int):
	print(dm)
