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

func digito_pressionado(digito: int) -> void:
	var valor = Gerador.get_valor_parametro_ativo()
	var chave = Gerador.get_chave_parametro_ativo()
	if valor == null: return
	
	var valor_str = str(valor)
	
	# um jeito meio estupido de fazer um clamp, mas funciona!
	Gerador.set_posicao_cursor(Gerador.parametro_posicao_cursor)
	
	if Gerador.parametro_posicao_cursor < valor_str.length():
		valor_str[Gerador.parametro_posicao_cursor] = str(digito)
	else:
		valor_str += str(digito)
	Gerador.set(chave, float(valor_str))

func andar_cursor(dir: int) -> void:
	Gerador.set_posicao_cursor(Gerador.parametro_posicao_cursor + dir)
