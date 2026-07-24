extends Node

func _ready() -> void:
	$sin.pressed.connect(_set_modo.bind(Gerador.ID_TIPO_ONDA.SIN))
	$quad.pressed.connect(_set_modo.bind(Gerador.ID_TIPO_ONDA.QUAD))
	$trig.pressed.connect(_set_modo.bind(Gerador.ID_TIPO_ONDA.TRIG))
	
func _set_modo(modo: Gerador.ID_TIPO_ONDA) -> void:
	Gerador.tipo_de_onda = modo
