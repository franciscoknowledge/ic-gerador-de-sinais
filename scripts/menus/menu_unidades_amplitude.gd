extends MenuResource
class_name MenuUnidadesAmplitude

func mult_amp(expoente: int):
	Gerador.digitacao_confirmada.emit(expoente)
	Gerador.set_menu(MenuLa.new())

func _init() -> void:
	reseta_grandeza_editada = false

	var botao_vpp = BotaoResource.new()
	botao_vpp.label = "Vpp"
	botao_vpp.acao = mult_amp.bind(0)
	
	var botao_mvpp = BotaoResource.new()
	botao_mvpp.label = "mVpp"
	botao_mvpp.acao = mult_amp.bind(-3)
	
	botoes = [botao_vpp, botao_mvpp]
