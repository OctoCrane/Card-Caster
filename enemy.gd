extends Actor

@export var detection : Area3D

var actor_list : Array
var main_actor : Actor

var look_speed := 0.4

var jump_duration := 1.0
var jump_timer = 0.0

func _ready() -> void:
	if detection:
		detection.body_entered.connect(on_detected_body_entered)
		detection.body_exited.connect(on_detected_body_exited)

func _process(_delta: float) -> void:
	handle_actor_list()
	
	if main_actor:
		var target := main_actor.global_position
		target.y = global_position.y
		
		look_at(target)

func _physics_process(delta: float) -> void:
	if is_on_floor():
		jump_timer += delta
		jump_timer = clamp(jump_timer, 0.0, jump_duration)
	else:
		jump_timer = 0
	
	pass

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

func get_move_input_dir() -> Vector2:
	return Vector2.ZERO

func get_jump(_held := false):
	return false
	if jump_timer >= jump_duration:
		return true
	else:
		return false

func on_detected_body_entered(body: Node3D):
	if body is Actor:
		actor_list.append(body)
func on_detected_body_exited(body: Node3D):
	if body is Actor:
		actor_list.erase(body)
