extends Area3D
class_name HitBox

@export var h_damage : int = 20 : set = set_health_damage, get = get_health_damage
@export var p_damage : int = 2 : set = set_poise_damage, get = get_poise_damage

func set_health_damage(value: int):
	h_damage = value

func get_health_damage():
	return h_damage

func set_poise_damage(value : int):
	p_damage = value

func get_poise_damage():
	return p_damage
