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

# TODO: tavelz trocar o sufixo de "-6" por "u". talvez o simbolo causará problemas
var sufixos = {
	-9: "n",
	-6: "µ",
	-3: "m",
	0: "",
	3: "k",
	6: "M",
	9: "G",
}

func _ready() -> void:
	Gerador.parametro_alterado.connect(_on_parametro_alterado)
	Gerador.cursor_movido.connect(_on_cursor_movido)
	_on_parametro_alterado("", null, null)

# TODO: essa função deve ser reutilizavel (TALVEZ)
# TODO: tem um bug onde o número é arrendondado pra cima tipo 9.99999999 -> 10,
# 		extremamente irritante
# eu realmente não me lembro como isso funciona, eu tirei de um script antigo de octave
func formatar(valor: float, decimais: int) -> String:
	if valor == 0: return "0"
	
	var sinal = "-" if valor < 0 else ""
	var valor_abs = abs(valor)
	
	# arrendondar o expoente para o multiplo de 3 mais proximo
	var expoente = int (floor(log(valor_abs) / log(10) / 3)) * 3
	expoente = clamp(expoente, -9, 9)
	
	var base = valor_abs / pow(10, expoente)
	var fator = pow(10, decimais)
	var base_arredondada = round(base * fator) / fator
	if base_arredondada >= 1000 and expoente < 9:
		expoente += 3
		base = valor_abs / pow(10, expoente)
	
	var sufixo = sufixos[expoente]
	var str = String.num(base, decimais)
	
	if str.contains("."):
		str = str.rstrip("0").rstrip(".")
		
	return sinal + str + sufixo

func _on_parametro_alterado(_parametro: String, _novo, _antigo):
	text = ""
	for chave in parametros:
		var parametro = parametros[chave]
		var valor = Gerador.get(parametro.variavel)
		var valor_str = "0"
		
		var debug = str(valor)
		
		if (valor != 0):
			valor_str = str(valor)
		
		if parametro.valor_enum == Gerador.parametro_ativo:
			var pos_min = 0
			var pos_max = valor_str.length()
			
			var pos_1 = clamp(Gerador.parametro_posicao_cursor, pos_min, pos_max)
			var pos_2 = clamp(Gerador.parametro_posicao_cursor + 1, pos_min, pos_max)

			valor_str = valor_str.insert(pos_2, "|")
			valor_str = valor_str.insert(pos_1, "|")
		else:
			valor_str = formatar(valor, 2)
		
		text += "%s: %s%s ; %s\n" % [parametro.label, valor_str, parametro.sufixo, debug]
	
func _on_cursor_movido():
	_on_parametro_alterado("", null, null)
