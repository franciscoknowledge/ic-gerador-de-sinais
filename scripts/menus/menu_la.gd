extends MenuResource
class_name MenuLa

func ao_entrar() -> void:
	match(Gerador.id_grandeza_sendo_editada):
		Gerador.ID_GRANDEZAS.AMPLITUDE: return
		Gerador.ID_GRANDEZAS.OFFSET: return
		
	Gerador.id_grandeza_sendo_editada = Gerador.ID_GRANDEZAS.AMPLITUDE

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
	
	var botao_vazio = BotaoResource.new()
	
	botoes = [botao_amplitude, botao_offset, botao_vazio, botao_vazio, botao_retornar]
