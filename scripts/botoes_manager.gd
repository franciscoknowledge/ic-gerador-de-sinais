extends Node

@onready var botoes = [$bot_1, $bot_2, $bot_3, $bot_4, $bot_5]

func _ready() -> void:
	for i in range(0, botoes.size()):
		var botao = botoes[i]
		botao.pressed.connect(_botao_pressionado.bind(i))
	
func _botao_pressionado(i: int) -> void:
	Gerador.botao_pressionado(i)
