extends Node3D
class_name Weapon

@export var anim_player : AnimationPlayer

@export var damage_per_bullet := 10
@export var bullet_count := 1
@export var inaccuracy := 0
@export var max_duration := 10.0

var dur := max_duration

@export_enum("Hitscan", "Projectile") var bullet_type := "Hitscan"
@export var offset := Vector3.ZERO

var weapon_manager : Node3D

var current_state := States.Equip
enum States {
	Equip,
	Idle,
	Shoot,
	Exit
}

func _ready() -> void:
	anim_player.play("equip")

func _process(delta: float) -> void:
	if current_state == States.Equip:
		if anim_player.current_animation != "equip":
			switch_states(States.Idle)
	elif current_state == States.Idle:
		dur -= delta
		if dur <= 0:
			switch_states(States.Exit)
		elif Input.is_action_pressed("attack"):
			switch_states(States.Shoot)
	elif current_state == States.Shoot:
		dur -= delta
		if anim_player.current_animation != "shoot":
			switch_states(States.Idle)

func shoot():
	var new_offset := offset + Vector3(randf() * inaccuracy, 0, randf() * inaccuracy)
	
	for i in range(bullet_count):
		if bullet_type == "Hitscan":
			var result = weapon_manager.raycast(new_offset)
			if result:
				if result.collider:
					if result.collider is Actor:
						weapon_manager.actor.damage(damage_per_bullet)

func switch_states(new_state : States):
	if new_state != current_state:
		if new_state == States.Idle:
			anim_player.play("RESET")
		elif new_state == States.Shoot:
			anim_player.play("shoot")
		elif new_state == States.Exit:
			anim_player.play("exit")
		
		current_state = new_state
