#extends Node
#
#func _ready() -> void:
#	$botoes.botao_pressionado.connect(_botao_display_pressionado)
#	
#func _botao_display_pressionado(botao: int) -> void:
#	Gerador.botao_pressionado(botao)

extends Node

@export var mostrar_buttons: bool = false:
	set(v):
		mostrar_buttons = v
		toggle_buttons(v)
	
var buttons: Array[TextureButton] = []

func _ready() -> void:
	if !OS.is_debug_build():
		mostrar_buttons = false
	
	var descendants = find_children("*")
	for d in descendants:
		if !(d is TextureButton): continue
		buttons.append(d)
		
	toggle_buttons(mostrar_buttons)
		
func toggle_buttons(v: bool) -> void:
	var cor = Color.WHITE if v else Color.TRANSPARENT
	
	for button in buttons:
		button.modulate = cor
