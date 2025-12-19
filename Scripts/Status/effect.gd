extends Resource
class_name Effect

@export var name : String
@export_enum("DOT", "Speed") var type : String
@export var max_duration : int = 10
@export var intensity : float = 1.0

var duration : int = max_duration
