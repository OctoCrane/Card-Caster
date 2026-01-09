extends Node3D
class_name WeaponManager

@export var actor : Actor
@export var head : Node3D

func raycast(offset := Vector3.ZERO):
	var to := (head.transform.basis * Vector3.ONE) * 1000
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(offset, to)
	var result = space_state.intersect_ray(query)
	
	return result
