extends Label

func _ready():
	Gerador.menu_alterado.connect(_on_menu_alterado)
	_on_menu_alterado(Gerador.menu_atual)
	
func _on_menu_alterado(menu: MenuResource):
	text = ""
	
	for botao in menu.botoes:
		print(botao.label)
		text = text + botao.label + "\n"
