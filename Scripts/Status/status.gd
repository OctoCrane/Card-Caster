extends Node
class_name Status

signal is_dead()
signal took_damage(damage: int)

@export var max_health : int = 100
@export var effects : Array[Effect]

var health : int:
	set(value):
		if value < 0:
			var dm = health - 0
			took_damage.emit(dm)
			is_dead.emit()
		elif value < health:
			var dm = health - value
			took_damage.emit(dm)
		
		health = clamp(value, 0, max_health)

func _ready():
	health = max_health
