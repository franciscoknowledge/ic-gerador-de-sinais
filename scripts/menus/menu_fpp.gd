extends MenuResource
class_name MenuFpp

func _init() -> void:
	var botao_vazio = BotaoResource.new()
	botao_vazio.label = ""
	botao_vazio.acao = func(): pass
	
	var botao_frequencia = BotaoResource.new()
	botao_frequencia.label = "Frequency"
	botao_frequencia.acao = func(): Gerador.set_parametro_ativo(Gerador.Parametros.FREQUENCIA)
	
	var botao_periodo = BotaoResource.new()
	botao_periodo.label = "Period"
	botao_periodo.acao = func(): Gerador.set_parametro_ativo(Gerador.Parametros.PERIODO)
	
	var botao_fase = BotaoResource.new()
	botao_fase.label = "Phase"
	botao_fase.acao = func(): Gerador.set_parametro_ativo(Gerador.Parametros.FASE)
	
	var botao_retornar = BotaoResource.new()
	botao_retornar.label = "Retornar"
	botao_retornar.acao = func(): Gerador.ir_para_menu(MenuPrincipal.new())
	
	botoes = [botao_frequencia, botao_periodo, botao_fase, botao_retornar]
