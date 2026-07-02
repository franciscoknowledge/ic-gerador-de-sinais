# TODO: salvar os valores ao apertar uma das grandezas
# TODO: se apertar cancel deve descartar o input no menu das grandezas

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

var parametro_para_menu = {
	Gerador.Parametros.FREQUENCIA: MenuUnidadesFreq.new(),
}

var is_modo_digitacao_ativo: bool = false
var parametro_atual: Gerador.Parametros = Gerador.Parametros.NENHUM
var chave_parametro_atual: String = "" # checar com .is_empty

var valor_antes_de_editar: float # checar com null

# godot
func _ready() -> void:
	for i in botoes_numeros.size():
		var botao: TextureButton = botoes_numeros[i]
		botao.pressed.connect(_bot_digito.bind(i))
		
	$cursor_frente.pressed.connect(_bot_mover_cursor.bind(1))
	$cursor_tras.pressed.connect(_bot_mover_cursor.bind(-1))
	$virgula.pressed.connect(inserir_virgula)
	$backspace.pressed.connect(_bot_backspace)
	$cancel.pressed.connect(_bot_cancel)
	$enter.pressed.connect(_bot_enter)
	
	Gerador.menu_alterado.connect(_on_menu_alterado)
	#Gerador.parametro_ativo_alterado.connect(salvar_valor)

#func _process(d) -> void:
#	print(is_modo_digitacao_ativo)

# helpers
func get_valor_atual() -> float:
	return Gerador.get_valor_parametro_ativo()
	
func get_valor_atual_string() -> String:
	return str(get_valor_atual())

func habilitar_digitacao() -> void:
	valor_antes_de_editar = Gerador.get(Gerador.get_chave_parametro_ativo())
	
	is_modo_digitacao_ativo = true
	parametro_atual = Gerador.parametro_ativo
	chave_parametro_atual = Gerador.get_chave_parametro_ativo()
	
	Gerador.set(chave_parametro_atual, 0)
	
	var menu = parametro_para_menu[Gerador.parametro_ativo]
	Gerador.ir_para_menu(menu)
	
func desabilitar_digitacao(salvar_mudancas: bool) -> void:
	if not salvar_mudancas and valor_antes_de_editar != null:
		Gerador.set(chave_parametro_atual, valor_antes_de_editar)
	
	if Gerador.parametro_ativo != Gerador.Parametros.NENHUM:
		# arredondar para 2 casas decimais antes de salvar
		var fator = pow(10, 2)
		var arrendondado = round(Gerador.get_valor_parametro_ativo() * fator) / fator
		
		Gerador.set(chave_parametro_atual, arrendondado)
	
	is_modo_digitacao_ativo = false
	parametro_atual = Gerador.Parametros.NENHUM
	chave_parametro_atual = ""

func salvar_valor() -> void:
	if not is_modo_digitacao_ativo: return
	
	valor_antes_de_editar = Gerador.get(chave_parametro_atual)
	
func inserir_digito(digito: int) -> void:
	if not is_modo_digitacao_ativo: return
	
	#var valor = get_valor_atual()
	var valor_str = get_valor_atual_string()
	
	var pos_virgula = valor_str.find(".")
	var cursor = Gerador.parametro_posicao_cursor
	
	var tamanho_antigo = valor_str.length()
	
	# isso deve ser parte de outra função
	# TODO: reduzir nesting, temp!
	#if not modo_digitacao:
	#	valor_str = ""
	#	cursor = 0
	#	modo_digitacao = true
	#	
	#	var menu = parametro_para_menu[Gerador.parametro_ativo]
	#	if menu:
	#		Gerador.ir_para_menu(menu)
	
	Gerador.set_posicao_cursor(cursor)
	
	if pos_virgula < 0:
		valor_str += str(digito)
	else:
		if cursor < valor_str.length():
			valor_str[cursor] = str(digito)
		else:
			valor_str += str(digito)
			
	var tamanho_novo = valor_str.length()
	Gerador.set(chave_parametro_atual, float(valor_str))
	
	if tamanho_antigo != tamanho_novo:
		Gerador.set_posicao_cursor(cursor + 1)
		
func inserir_virgula() -> void:
	if not is_modo_digitacao_ativo: return
	
	var valor = get_valor_atual()
	var valor_str = get_valor_atual_string()
	
	var pos_virgula_original = valor_str.find(".")
	var pos_nova_virgula = Gerador.parametro_posicao_cursor
	
	if pos_virgula_original < 0:
		pos_virgula_original = valor_str.length()
		
	if pos_nova_virgula > valor_str.length():
		pos_nova_virgula = valor_str.length() - 1
	
	var mult = pos_nova_virgula - pos_virgula_original
	var novo_valor = valor * pow(10, mult)
	
	Gerador.set(chave_parametro_atual, novo_valor)
	
func mover_cursor(direcao: int) -> void:
	Gerador.set_posicao_cursor(Gerador.parametro_posicao_cursor + direcao)
	
# botoes / conexões dos sinais
func _on_menu_alterado(novo: MenuResource):
	if not novo.reseta_parametro: return
	desabilitar_digitacao(false)

func _bot_cancel() -> void:
	desabilitar_digitacao(false)
	
func _bot_enter() -> void:
	desabilitar_digitacao(true)
	
func _bot_mover_cursor(direcao: int) -> void:
	if not is_modo_digitacao_ativo:
		habilitar_digitacao()
		return
		
	mover_cursor(direcao)
	
func _bot_backspace() -> void:
	if not is_modo_digitacao_ativo:
		habilitar_digitacao()
		return
	
	var valor_str = get_valor_atual_string()
	var onde = Gerador.parametro_posicao_cursor - 1
	
	if onde < 0: onde = 0
	if valor_str.find(".") == onde:
		Gerador.set_posicao_cursor(Gerador.parametro_posicao_cursor - 1)
		return
	
	valor_str = valor_str.erase(onde, 1)
	
	if valor_str.is_empty():	
		valor_str = "0.0"
		
	Gerador.set(chave_parametro_atual, float(valor_str))
	Gerador.set_posicao_cursor(Gerador.parametro_posicao_cursor - 1)
	
func _bot_digito(digito: int) -> void:
	if Gerador.parametro_ativo == Gerador.Parametros.NENHUM: return
	
	if not is_modo_digitacao_ativo:
		habilitar_digitacao()
		return
		
	inserir_digito(digito)
