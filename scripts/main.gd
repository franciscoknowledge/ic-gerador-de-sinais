extends Node

func _ready() -> void:
	$botoes.botao_pressionado.connect(_botao_display_pressionado)
	
func _botao_display_pressionado(botao: int) -> void:
	Gerador.botao_pressionado(botao)
