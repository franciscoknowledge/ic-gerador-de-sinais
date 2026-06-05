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

var valor_anterior
var parametro_anterior

func _ready() -> void:
	for i in botoes_numeros.size():
		var botao: TextureButton = botoes_numeros[i]
		botao.pressed.connect(digito_pressionado.bind(i))
		
	$cursor_frente.pressed.connect(andar_cursor.bind(1))
	$cursor_tras.pressed.connect(andar_cursor.bind(-1))
	$virgula.pressed.connect(inserir_virgula)
	$backspace.pressed.connect(backspace)
	$cancel.pressed.connect(cancel)
	
	Gerador.parametro_ativo_alterado.connect(salvar_valor)

# debug!	
#func _process(_delta: float) -> void:
#	print(get_valor_parametro())

func recuperar_valor() -> void:
	if valor_anterior == null: return
	
	var chave = Gerador.get_chave_parametro(parametro_anterior)
	if not chave: return
	
	Gerador.set(chave, valor_anterior)

func salvar_valor(novo: Gerador.Parametros, _antigo: Gerador.Parametros) -> void:
	var chave = Gerador.get_chave_parametro_ativo()
	if not chave: return
	
	valor_anterior = Gerador.get(chave)
	parametro_anterior = novo
	
func cancel() -> void:
	recuperar_valor()
	parametro_anterior = null
	Gerador.set_parametro_ativo(Gerador.Parametros.NENHUM)

func digito_pressionado(digito: int) -> void:
	var valor = Gerador.get_valor_parametro_ativo()
	var chave = Gerador.get_chave_parametro_ativo()
	if valor == null: return
	
	var valor_str = str(valor)
	var pos_virgula = valor_str.find(".")
	var cursor = Gerador.parametro_posicao_cursor
	
	var tamanho_antigo = valor_str.length()
	
	Gerador.set_posicao_cursor(cursor)
	
	# testando outros metodos de inserir os numeros
	#if (pos_virgula < 0) or (cursor < pos_virgula):
	#	valor_str = valor_str.insert(cursor, str(digito))
	#else:
	#	if cursor < valor_str.length():
	#		valor_str[cursor] = str(digito)
	#	else:
	#		valor_str += str(digito)
	
	#if Gerador.parametro_posicao_cursor < valor_str.length():
	#	valor_str[Gerador.parametro_posicao_cursor] = str(digito)
	#else:
	#	valor_str += str(digito)
	
	if pos_virgula < 0:
		valor_str += str(digito)
	else:
		if cursor < valor_str.length():
			valor_str[cursor] = str(digito)
		else:
			valor_str += str(digito)
			
	var tamanho_novo = valor_str.length()
	Gerador.set(chave, float(valor_str))
	
	if tamanho_antigo != tamanho_novo:
		Gerador.set_posicao_cursor(cursor + 1)
		
func backspace() -> void:
	var valor = Gerador.get_valor_parametro_ativo()
	var chave = Gerador.get_chave_parametro_ativo()
	if valor == null: return
	
	var valor_str = str(valor)
	var onde = Gerador.parametro_posicao_cursor - 1
	
	if onde < 0: onde = 0
	if valor_str.find(".") == onde:
		Gerador.set_posicao_cursor(Gerador.parametro_posicao_cursor - 1)
		return
	
	valor_str = valor_str.erase(onde, 1)
	
	if valor_str.is_empty():	
		valor_str = "0.0"
		
	Gerador.set(chave, float(valor_str))
	Gerador.set_posicao_cursor(Gerador.parametro_posicao_cursor - 1)
	
func inserir_virgula() -> void:
	var valor = Gerador.get_valor_parametro_ativo()
	var chave = Gerador.get_chave_parametro_ativo()
	if valor == null: return
	
	var valor_str = str(valor)
	
	var pos_virgula_original = valor_str.find(".")
	var pos_nova_virgula = Gerador.parametro_posicao_cursor
	
	if pos_virgula_original < 0:
		pos_virgula_original = valor_str.length()
		
	if pos_nova_virgula > valor_str.length():
		print("hm")
		pos_nova_virgula = valor_str.length() - 1
	
	var mult = pos_nova_virgula - pos_virgula_original
	var novo_valor = valor * pow(10, mult)
	
	Gerador.set(chave, novo_valor)

func andar_cursor(dir: int) -> void:
	Gerador.set_posicao_cursor(Gerador.parametro_posicao_cursor + dir)
