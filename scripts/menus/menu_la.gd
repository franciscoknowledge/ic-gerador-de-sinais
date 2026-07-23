extends MenuResource
class_name MenuLa

func _init() -> void:
	reseta_grandeza_editada = false
	
	var botao_amplitude = BotaoResource.new()
	botao_amplitude.label = "Amplitude"
	botao_amplitude.acao = func(): Gerador.set_grandeza_editada(Gerador.ID_GRANDEZAS.AMPLITUDE)
	
	var botao_offset = BotaoResource.new()
	botao_offset.label = "Offset"
	botao_offset.acao = func(): Gerador.set_grandeza_editada(Gerador.ID_GRANDEZAS.OFFSET)
	
	var botao_retornar = BotaoResource.new()
	botao_retornar.label = "Retornar"
	botao_retornar.acao = func(): Gerador.set_menu(MenuPrincipal.new())
	
	botoes = [botao_amplitude, botao_offset, botao_retornar]
