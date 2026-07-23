extends MenuResource
class_name MenuPrincipal

func _init() -> void:
	reseta_grandeza_editada = true
	
	var botao_vazio = BotaoResource.new()
	botao_vazio.label = ""
	botao_vazio.acao = func(): pass
	
	var botao_fpp = BotaoResource.new()
	botao_fpp.label = "Frequency/Period/Phase menu"
	botao_fpp.acao = func(): Gerador.set_menu(MenuFpp.new())
	
	var botao_amplitude = BotaoResource.new()
	botao_amplitude.label = "Amplitude/Level Menu"
	botao_amplitude.acao = func(): Gerador.set_menu(MenuLa.new())
	
	botoes = [botao_fpp, botao_amplitude]
