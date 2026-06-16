extends MenuResource
class_name MenuUnidadesFreq

func mult_freq(expoente: int):
	Gerador.frequencia *= (10 ** expoente)
	Gerador.ir_para_menu(MenuFpp.new())

func _init() -> void:
	reseta_parametro = false

	var botao_hz = BotaoResource.new()
	botao_hz.label = "hz"
	botao_hz.acao = mult_freq.bind(0)
	
	var botao_khz = BotaoResource.new()
	botao_khz.label = "Khz"
	botao_khz.acao = mult_freq.bind(3)
	
	var botao_mega_hz = BotaoResource.new()
	botao_mega_hz.label = "Mhz"
	botao_mega_hz.acao = mult_freq.bind(6)
	
	var botao_mili_hz = BotaoResource.new()
	botao_mili_hz.label = "mhz"
	botao_mili_hz.acao = mult_freq.bind(-3)
	
	var botao_cancel = BotaoResource.new()
	botao_cancel.label = "Cancel"
	botao_cancel.acao = func(): Gerador.ir_para_menu(MenuFpp.new())
	
	botoes = [botao_mega_hz, botao_khz, botao_hz, botao_mili_hz, botao_cancel]
