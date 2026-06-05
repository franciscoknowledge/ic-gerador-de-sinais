extends Label

var parametros = {
	
	frequencia = {
		label = "Frequência",
		sufixo = "hz",
		valor_enum = Gerador.Parametros.FREQUENCIA,
		variavel = "frequencia"
	},
	
	fase = {
		label = "Fase",
		sufixo = "°",
		valor_enum = Gerador.Parametros.FASE,
		variavel = "fase"
	},
	
	amplitude = {
		label = "Amplitude",
		sufixo = "V",
		valor_enum = Gerador.Parametros.AMPLITUDE,
		variavel = "amplitude"
	},
	
	periodo = {
		label = "Periodo",
		sufixo = "s",
		valor_enum = Gerador.Parametros.PERIODO,
		variavel = "periodo"
	},
	
}

func _ready() -> void:
	Gerador.parametro_alterado.connect(_on_parametro_alterado)
	Gerador.cursor_movido.connect(_on_cursor_movido)
	_on_parametro_alterado("", null, null)

func _on_parametro_alterado(_parametro: String, _novo, _antigo):
	text = ""
	for chave in parametros:
		var parametro = parametros[chave]
		var valor = Gerador.get(parametro.variavel)
		var valor_str = "0"
		
		if (valor != 0):
			valor_str = str(valor)
		
		if parametro.valor_enum == Gerador.parametro_ativo:
			var pos_min = 0
			var pos_max = valor_str.length()
			
			var pos_1 = clamp(Gerador.parametro_posicao_cursor, pos_min, pos_max)
			var pos_2 = clamp(Gerador.parametro_posicao_cursor + 1, pos_min, pos_max)

			valor_str = valor_str.insert(pos_2, "|")
			valor_str = valor_str.insert(pos_1, "|")
		
		text += "%s: %s%s\n" % [parametro.label, valor_str, parametro.sufixo]
	
func _on_cursor_movido():
	_on_parametro_alterado("", null, null)
