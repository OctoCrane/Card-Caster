extends State
class_name WeaponShoot

@export var anim_player : AnimationPlayer

@export var damage_per_bullet := 10
@export var bullet_count := 1

@export var animation : Animation

func enter():
	anim_player.play("shoot")
