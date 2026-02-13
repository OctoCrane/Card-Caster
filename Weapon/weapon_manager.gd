extends Node3D
class_name WeaponManager

@export var actor : Actor
@export var head : Node3D

func raycast(offset := Vector3.ZERO, ray_range := 1000):
	for child in get_children():
		if child is Path3D:
			child.queue_free()
	
	var ray_origin : Vector3
	var ray_end : Vector3
	
	if head is Camera3D:
		var centre = head.get_viewport().get_visible_rect().size/2
		ray_origin = head.project_ray_origin(centre)
		ray_end = ray_origin + head.project_ray_normal(centre) * ray_range
	else:
		ray_origin = head.global_position + offset
		ray_end = ray_origin + head.global_transform.basis * Vector3(0,0,-ray_range)
	
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_areas = true
	query.collision_mask = (1 << 1 - 1) | (1 << 2 - 1) # Collision Mask 1 and 2
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	if result:
		add_debug_line(ray_origin, result.position)
	else:
		add_debug_line(ray_origin, ray_end)
	
	return result

func add_debug_line(origin:Vector3, end:Vector3):
	var line := Path3D.new()
	
	var curve := Curve3D.new()
	curve.add_point(origin)
	curve.add_point(end)
	
	line.curve = curve
	line.top_level = true
	
	add_child(line)
