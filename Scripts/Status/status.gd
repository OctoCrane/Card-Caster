extends Resource
class_name Status

signal is_dead()

@export var max_health : int = 100
@export var effects : Array[Effect] 

var health : int = max_health:
	set(value):
		if value <= 0:
			if health > 0:
				is_dead.emit()
			health = 0
		elif value > max_health:
			health = max_health
		else:
			health = value
	get:
		return health
