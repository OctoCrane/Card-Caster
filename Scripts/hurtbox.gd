extends Area3D
class_name HurtBox

@export var actor : Actor
@export var damage_multiplier := 1.0

func _ready() -> void:
	area_entered.connect(_area_entered)

func _area_entered(area: Area3D):
	if area is HitBox:
		actor.status.health -= area.get_health_damage() * damage_multiplier
