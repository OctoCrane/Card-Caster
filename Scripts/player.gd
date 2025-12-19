extends CharacterBody3D
class_name Player

@export var baseSpeed := 5.0
@export var lookSensitivity := 0.003

@export_group("References")
@export var head : Node3D
@export var hurtbox : HurtBox

var time_since_last_tick := 0.0
var tick_interval := 0.5
var tick_count := 0

var speed := baseSpeed

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		rotate_y(-event.relative.x * lookSensitivity)
		head.rotate_x(-event.relative.y * lookSensitivity)
		
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-85), deg_to_rad(85))
	
	if event.is_action_pressed("menu"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			get_tree().quit()
	
	if event.is_action_pressed("attack"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	time_since_last_tick += delta
	if time_since_last_tick >= tick_interval:
		perform_tick()
		time_since_last_tick -= tick_interval

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	

	move_and_slide()

func perform_tick():
	tick_count += 1
	process_effects(hurtbox.status.effects)

func process_effects(effects : Array[Effect]):
	for effect in effects:
		if effect == null:
			effects.erase(effect)
			break
		
		effect.duration -= 1
		
		if effect.type == "DOT":
			hurtbox.status.health -= int(effect.intensity)
		
		if effect.type == "Speed":
			speed = baseSpeed * effect.intensity
		
		if effect.duration <= 0:
			effects.erase(effect)
			speed = baseSpeed
		
