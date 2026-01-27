extends Actor
class_name Player

@export var start_deck : Array[CardProperties]
@export var timer_arr : Array[Timer]
@export var card_container : Node
@export var weapon_manager : Node3D

@export var head : Node3D
@export var max_look_angle := 90.

@export_group("Preferences")
@export var mouse_sensitivity := 0.002
#@export var controller_sensitivity := 0.001

var placeholder_tex : Texture = load("res://Assets/2D/Cards/CardPlaceHolder.png")

var input_mode := InputMode.KEYBOARD_MOUSE

var main_cards : Array[CardProperties]

var reserve_deck : Array[CardProperties]

enum InputMode {
	KEYBOARD_MOUSE = 0,
	CONTROLLER = 1,
}

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	timer_arr[0].timeout.connect(card1_replace)
	timer_arr[1].timeout.connect(card2_replace)
	timer_arr[2].timeout.connect(card3_replace)
	timer_arr[3].timeout.connect(card4_replace)
	
	init_deck()

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
	
	if Input.is_action_just_pressed("1"):
		use_deck(0)
	elif Input.is_action_just_pressed("2"):
		use_deck(1)
	elif Input.is_action_just_pressed("3"):
		use_deck(2)
	elif Input.is_action_just_pressed("4"):
		use_deck(3)
	
	handle_camera(event)

func apply_texture(texture :):
	var texture_rect = TextureRect.new()
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.custom_minimum_size = Vector2(66.0, 96.0)
	texture_rect.texture = texture
	card_container.add_child(texture_rect)

func show_deck():
	if card_container.get_children():
		for child in card_container.get_children():
			card_container.remove_child(child)
	
	for card in main_cards:
		if card == null:
			apply_texture(placeholder_tex)
		else:
			apply_texture(card.texture)

func init_deck():
	var shuffle_deck = start_deck
	shuffle_deck.shuffle()
	
	for i in range(4):
		main_cards.append(shuffle_deck[i])
	
	for i in range(len(start_deck) - 4):
		reserve_deck.append(start_deck[i + 4])
	
	show_deck()

func use_deck(pos : int):
	if main_cards[pos] == null:
		return
	
	if use_card(main_cards[pos]):
		main_cards[pos] = null
		timer_arr[pos].start()
		show_deck()

func use_card(card : CardProperties) -> bool:
	if card.scene == null:
		return true
	
	if card.type == 0:
		var weapon_equipped := false
		for child in weapon_manager.get_children():
			if child is Weapon:
				weapon_equipped = true
		if not weapon_equipped:
			print("Hey")
			var weapon = card.scene.instantiate()
			weapon.weapon_manager = weapon_manager
			weapon_manager.add_child(weapon)
		else:
			return false
	else: 
		return true
	
	reserve_deck.append(card)
	return true

func replace_card(pos : int):
	if main_cards[pos] == null:
		main_cards[pos] = reserve_deck[0]
		reserve_deck.remove_at(0)

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

# Replaces the cards on a timer (Couldn't think of a better way to do this)
func card1_replace():
	replace_card(0)
	show_deck()
func card2_replace():
	replace_card(1)
	show_deck()
func card3_replace():
	replace_card(2)
	show_deck()
func card4_replace():
	replace_card(3)
	show_deck()
