extends Actor
class_name Player

@export var start_deck : Array[CardProperties]
@export var card_container : Node

@export var head : Node3D
@export var max_look_angle := 90.

@export_group("Preferences")
@export var mouse_sensitivity := 0.002
#@export var controller_sensitivity := 0.001

var input_mode := InputMode.KEYBOARD_MOUSE

var card1 : CardProperties
var card2 : CardProperties
var card3 : CardProperties
var card4 : CardProperties

var reserve_deck : Array[CardProperties]

enum InputMode {
	KEYBOARD_MOUSE = 0,
	CONTROLLER = 1,
}

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	init_deck()
	show_deck()

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

func show_deck():
	if card_container.get_children():
		for child in card_container.get_children():
			card_container.remove_child(child)
	
	apply_texture(card1.texture)
	apply_texture(card2.texture)
	apply_texture(card3.texture)
	apply_texture(card4.texture)
	

func apply_texture(texture : Texture):
	var texture_rect = TextureRect.new()
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.custom_minimum_size = Vector2(66.0, 96.0)
	texture_rect.texture = texture
	card_container.add_child(texture_rect)

func init_deck():
	start_deck.shuffle()
	
	card1 = start_deck[0]
	card2 = start_deck[1]
	card3 = start_deck[2]
	card4 = start_deck[3]
	
	for i in range(len(start_deck) - 4):
		reserve_deck.append(start_deck[i + 4])


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
