extends Node

@onready var labels: Array[Label] = [$botao_1, $botao_2, $botao_3, $botao_4, $botao_5]

func _ready():
	Gerador.menu_alterado.connect(_on_menu_alterado)
	_on_menu_alterado(Gerador.menu_atual)
	
func _on_menu_alterado(menu: MenuResource) -> void:
	for i in range(labels.size()):
		var label = labels[i]
		var botao
		
		if i >= menu.botoes.size():
			label.text = ""
			continue
			
		botao = menu.botoes[i]
		label.text = botao.label
