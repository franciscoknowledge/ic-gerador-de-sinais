extends Node

@onready var botoes_numeros = [
	$numeros/num_0,
	$numeros/num_1,
	$numeros/num_2,
	$numeros/num_3,
	$numeros/num_4,
	$numeros/num_5,
	$numeros/num_6,
	$numeros/num_7,
	$numeros/num_8,
	$numeros/num_9,
]

func _ready() -> void:
	for i in botoes_numeros.size():
		var botao: TextureButton = botoes_numeros[i]
		botao.pressed.connect(digito_pressionado.bind(i))
		
	$cursor_frente.pressed.connect(andar_cursor.bind(1))
	$cursor_tras.pressed.connect(andar_cursor.bind(-1))

# debug!	
#func _process(_delta: float) -> void:
#	print(get_valor_parametro())

func get_chave_parametro() -> String:
	var param = Gerador.parametro_selecionado
	var mapa = {
		Gerador.Parametros.FREQUENCIA: "frequencia",
		Gerador.Parametros.FASE: "fase",
		Gerador.Parametros.AMPLITUDE: "amplitude",
	}
	
	if not param in mapa:
		return ""
		
	return mapa[param]

func get_valor_parametro():
	var chave = get_chave_parametro()
	if chave == "": return
	
	return Gerador.get(chave)
	
func get_posicao_virgula(string: String) -> int:
	for i in string.length():
		if string[i] == ".":
			return i
			
	return -1

func digito_pressionado(digito: int) -> void:
	var valor = get_valor_parametro()
	var chave = get_chave_parametro()
	if valor == null: return
	
	var valor_str = str(valor)
	
	set_cursor(Gerador.cursor_parametro)
	
	if Gerador.cursor_parametro < valor_str.length():
		valor_str[Gerador.cursor_parametro] = str(digito)
	else:
		valor_str += str(digito)
	Gerador.set(chave, float(valor_str))

func set_cursor(para: int) -> void:
	var valor = get_valor_parametro()
	if valor == null:
		Gerador.cursor_parametro = 0
		return
	
	var valor_str = str(valor)
	
	var cursor_anterior = Gerador.cursor_parametro
	
	var valor_min = 0
	var valor_max = valor_str.length() + 1
	
	Gerador.cursor_parametro = clamp(para, valor_min, valor_max)
	
	var direcao = para - cursor_anterior
	var pos_virgula = get_posicao_virgula(valor_str)
	
	if pos_virgula < 0: return
	
	if Gerador.cursor_parametro == pos_virgula:
		if direcao < 0:
			Gerador.cursor_parametro -= 1
		elif direcao > 0:
			Gerador.cursor_parametro += 1
			
func andar_cursor(dir: int) -> void:
	set_cursor(Gerador.cursor_parametro + dir)
