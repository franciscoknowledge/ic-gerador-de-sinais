extends Node

signal botao_pressionado(botao: int)
@onready var botoes: Array[TextureButton] = [$bot_1, $bot_2, $bot_3, $bot_4, $bot_5]

func _ready() -> void:
	for i in range(0, botoes.size()):
		var botao = botoes[i]
		botao.pressed.connect(func(): botao_pressionado.emit(i))
		
	pass
