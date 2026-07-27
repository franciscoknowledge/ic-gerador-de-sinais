extends Node

@export var mostrar_buttons: bool = false:
	set(v):
		mostrar_buttons = v
		toggle_buttons(v)
	
var buttons: Array[TextureButton] = []

func _ready() -> void:
	_init_buttons_debug()
		
func toggle_buttons(v: bool) -> void:
	var cor = Color.WHITE if v else Color.TRANSPARENT
	
	for button in buttons:
		button.modulate = cor

func _init_buttons_debug() -> void:
	if not OS.is_debug_build():
		mostrar_buttons = false
	
	var descendants = find_children("*")
	for d in descendants:
		if not (d is TextureButton): continue
		buttons.append(d)
		
	toggle_buttons(mostrar_buttons)
