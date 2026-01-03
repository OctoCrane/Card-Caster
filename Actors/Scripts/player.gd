extends Actor
class_name Player

@export var head : Node3D
@export var max_look_angle := 90.

@export_group("Preferences")
@export var mouse_sensitivity := 0.002
#@export var controller_sensitivity := 0.001


var input_mode := InputMode.KEYBOARD_MOUSE

enum InputMode {
	KEYBOARD_MOUSE = 0,
	CONTROLLER = 1,
}

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	# Determines Input Type
	if event is InputEventMouse or event is InputEventKey:
		input_mode = InputMode.KEYBOARD_MOUSE
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		input_mode = InputMode.CONTROLLER
	
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("menu"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			get_tree().quit()
	
	handle_camera(event)
	
func handle_camera(event: InputEvent):
	if event is InputEventMouseMotion:
		var mouse_dir : Vector2 = -event.screen_relative
		rotate_y(mouse_dir.x * mouse_sensitivity)
		head.rotate_x(mouse_dir.y * mouse_sensitivity)
	
	head.rotation_degrees.x = clamp(head.rotation_degrees.x, -max_look_angle, max_look_angle)

func get_move_input_dir():
	return Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

func get_jump(held := false):
	if not held:
		return Input.is_action_just_pressed("jump")
	else:
		return Input.is_action_just_pressed("jump")

func get_attack(held := false):
	if not held:
		return Input.is_action_just_pressed("attack")
	else:
		return Input.is_action_pressed("attack")
