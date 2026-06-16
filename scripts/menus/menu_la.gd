extends MenuResource
class_name MenuLa

func _init() -> void:
	reseta_parametro = true
	
	var botao_amplitude = BotaoResource.new()
	botao_amplitude.label = "Amplitude"
	botao_amplitude.acao = func(): Gerador.set_parametro_ativo(Gerador.Parametros.AMPLITUDE)
	
	var botao_retornar = BotaoResource.new()
	botao_retornar.label = "Retornar"
	botao_retornar.acao = func(): Gerador.ir_para_menu(MenuPrincipal.new())
	
	botoes = [botao_amplitude, botao_retornar]
	pass
