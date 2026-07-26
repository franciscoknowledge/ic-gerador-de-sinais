extends Node

@export var output_ativo := false

@onready var highlight = $sprite_highlight
@onready var label = $label_output
@onready var botao = $botao

func _ready() -> void:
	botao.pressed.connect(_on_pressed)
	update_visual()
	
func update_visual() -> void:
	highlight.visible = output_ativo
	
	var estado = "ON" if output_ativo else "OFF"
	label.text = "OUTPUT: %s" % [estado]
	
func _on_pressed() -> void:
	output_ativo = not output_ativo
	update_visual()
