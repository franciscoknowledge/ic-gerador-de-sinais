class_name ParamsEngenharia
extends Resource

@export var base: String
@export var expoente: int
@export var sufixo: String

func _init(b: String, e: int, s: String) -> void:
	base = b
	expoente = e
	sufixo = s
