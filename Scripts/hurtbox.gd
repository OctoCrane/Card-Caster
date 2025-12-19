extends Area3D
class_name HurtBox

@export var status : Status

func _ready() -> void:
	area_entered.connect(_area_entered)

func _area_entered(area: Area3D):
	if area is HitBox:
		status.health -= area.get_health_damage()
