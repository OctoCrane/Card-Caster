extends Resource
class_name CardProperties

@export var name : StringName
@export_range(0, 9, 1.0) var mana_cost : int

@export var texture : Texture
@export var collection : StringName

@export_enum("Weapon", "Spawnable", "Effect") var type
@export var scene : PackedScene
