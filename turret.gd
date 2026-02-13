extends Actor
class_name Turret

@export var detection : Area3D
@export var weapon_manager : WeaponManager
@export var head : Node3D

var actor_list : Array
var main_actor : Actor

func _ready() -> void:
	if detection:
		detection.body_entered.connect(on_detected_body_entered)
		detection.body_exited.connect(on_detected_body_exited)

func get_attack(_held := false) -> bool:
	return false

func _process(_delta: float) -> void:
	handle_actor_list()
	print(main_actor)
	
	if main_actor:
		var target := main_actor.global_position
		
		head.look_at(target)

func handle_actor_list():
	if actor_list.is_empty():
		main_actor = null
		return
	
	for actor in actor_list:
		if main_actor != null:
			var actor_line = to_local(actor.global_position)
			var min_line = to_local(main_actor.global_position)
			if actor_line.length() < min_line.length():
				main_actor = actor
		else:
			main_actor = actor

func on_detected_body_entered(body: Node3D):
	if body is Actor:
		actor_list.append(body)

func on_detected_body_exited(body: Node3D):
	if body is Actor:
		actor_list.erase(body)
