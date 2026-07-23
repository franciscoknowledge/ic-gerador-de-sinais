extends MenuResource
class_name MenuUnidadesFase

func _init() -> void:
	reseta_grandeza_editada = false

	var botao_deg = BotaoResource.new()
	botao_deg.label = "°"
	botao_deg.acao = func(): Gerador.digitacao_confirmada.emit(0); Gerador.set_menu(MenuFpp.new())
	
	botoes = [botao_deg]
