extends MenuResource
class_name MenuUnidadesFreq

func mult_freq(expoente: int):
	Gerador.digitacao_confirmada.emit(expoente)
	Gerador.set_menu(MenuFpp.new())

func _init() -> void:
	reseta_grandeza_editada = false
	
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
	
	botoes = [botao_mega_hz, botao_khz, botao_hz, botao_mili_hz]
