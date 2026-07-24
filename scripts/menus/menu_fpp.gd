extends MenuResource
class_name MenuFpp

func ao_entrar() -> void:
	match(Gerador.id_grandeza_sendo_editada):
		Gerador.ID_GRANDEZAS.FREQUENCIA: return
		Gerador.ID_GRANDEZAS.FASE: return
		Gerador.ID_GRANDEZAS.PERIODO: return
		
	Gerador.id_grandeza_sendo_editada = Gerador.ID_GRANDEZAS.FREQUENCIA
	
func _init() -> void:
	reseta_grandeza_editada = false
	
	var botao_vazio = BotaoResource.new()
	botao_vazio.label = ""
	botao_vazio.acao = func(): pass
	
	var botao_frequencia = BotaoResource.new()
	botao_frequencia.label = "Frequency"
	botao_frequencia.acao = func(): Gerador.set_grandeza_editada(Gerador.ID_GRANDEZAS.FREQUENCIA)
	
	var botao_periodo = BotaoResource.new()
	botao_periodo.label = "Period"
	botao_periodo.acao = func(): Gerador.set_grandeza_editada(Gerador.ID_GRANDEZAS.PERIODO)
	
	var botao_fase = BotaoResource.new()
	botao_fase.label = "Phase"
	botao_fase.acao = func(): Gerador.set_grandeza_editada(Gerador.ID_GRANDEZAS.FASE)
	
	var botao_retornar = BotaoResource.new()
	botao_retornar.label = "Retornar"
	botao_retornar.acao = func(): Gerador.set_menu(MenuPrincipal.new())
	
	# o botao vazio é onde seria periodo
	botoes = [botao_frequencia, botao_fase, botao_vazio, botao_vazio, botao_retornar]
