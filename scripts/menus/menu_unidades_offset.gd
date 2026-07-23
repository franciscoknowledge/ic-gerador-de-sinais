extends MenuResource
class_name MenuUnidadesOffset

func mult_off(expoente: int):
	Gerador.digitacao_confirmada.emit(expoente)
	Gerador.set_menu(MenuLa.new())

func _init() -> void:
	reseta_grandeza_editada = false

	var botao_v = BotaoResource.new()
	botao_v.label = "V"
	botao_v.acao = mult_off.bind(0)
	
	var botao_mv = BotaoResource.new()
	botao_mv.label = "mV"
	botao_mv.acao = mult_off.bind(-3)
	
	botoes = [botao_v, botao_mv]
