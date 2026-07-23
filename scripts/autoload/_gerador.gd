extends Node

signal menu_alterado(novo: MenuResource)
signal parametro_alterado(parametro: String, novo, antigo)
signal cursor_movido()
signal parametro_ativo_alterado(novo: Parametros, antigo: Parametros)
signal digitacao_confirmada()

enum Parametros {
	NENHUM = 0,
	
	FREQUENCIA = 1,
	FASE = 2,
	AMPLITUDE = 3,
	PERIODO = 4,
	OFFSET = 5,
	SIMETRIA = 6,
}

const NOMES_PARAMETROS = {
	Parametros.FREQUENCIA: "frequencia",
	Parametros.FASE: "fase",
	Parametros.AMPLITUDE: "amplitude",
	Parametros.PERIODO: "periodo",
	Parametros.OFFSET: "offset",
	Parametros.SIMETRIA: "simetria",
}

var frequencia: float = 100000.0:
	set(value):
		frequencia = value
		parametro_alterado.emit("frequencia", value, frequencia)
		
var fase: float = 0.0:
	set(value):
		fase = value
		parametro_alterado.emit("fase", value, fase)
		
var amplitude: float = 0.0:
	set(value):
		amplitude = value
		parametro_alterado.emit("amplitude", value, amplitude)
		
var periodo: float = 0.0:
	set(value):
		periodo = value
		parametro_alterado.emit("periodo", value, amplitude)
		
var offset: float = 0.0:
	set(value):
		offset = value
		parametro_alterado.emit("offset", value, amplitude)
	
var parametro_posicao_cursor = 0

var parametro_ativo = Parametros.NENHUM
var menu_atual: MenuResource = MenuPrincipal.new()
var menu_anterior: MenuResource

func _ready() -> void:
	menu_alterado.emit(menu_atual)

# public
func ir_para_menu(menu: MenuResource) -> void:
	if (Gerador.menu_atual.get_script() == menu.get_script()):
		return
		
	if (menu.reseta_parametro):
		Gerador.set_parametro_ativo(Parametros.NENHUM)
	
	menu_anterior = menu_atual
	
	menu_atual = menu
	menu_alterado.emit(menu)
	
	#set_parametro_ativo(Parametros.NENHUM)
	
func botao_pressionado(indice: int) -> void:
	if (not menu_atual):
		print_debug("botao_pressionado, porém menu_atual é nulo")
		return
		
	if (indice > menu_atual.botoes.size() - 1): 
		print_debug("o indice é maior do que a lista de botões")
		return
		
	if (not menu_atual.botoes[indice].acao):
		print_debug("esse botao não tem uma ação gng")
		return
	
	menu_atual.botoes[indice].acao.call()
	
func set_parametro_ativo(parametro: Parametros):
	var antigo = parametro_ativo
	
	parametro_posicao_cursor = 0
	parametro_ativo = parametro
	cursor_movido.emit()
	parametro_ativo_alterado.emit(parametro_ativo, antigo)
	
func set_posicao_cursor(pos):
	var valor = get_valor_parametro_ativo()
	if valor == null:
		parametro_posicao_cursor = 0
		return
	
	var valor_str = str(valor)
	
	var cursor_anterior = parametro_posicao_cursor
	
	var valor_min = 0
	var valor_max = valor_str.length() + 1
	
	parametro_posicao_cursor = clamp(pos, valor_min, valor_max)
	
	var direcao = pos - cursor_anterior
	var pos_virgula = -1
	
	for i in valor_str.length():
		if valor_str[i] == ".":
			pos_virgula = i
			break
	
	if parametro_posicao_cursor == pos_virgula:
		if direcao < 0:
			parametro_posicao_cursor -= 1
		elif direcao > 0:
			parametro_posicao_cursor += 1
			
	if cursor_anterior != parametro_posicao_cursor:
		cursor_movido.emit()
	
# getters
func get_chave_parametro(parametro: Parametros) -> String:
	var param = parametro
	var mapa = {
		Parametros.FREQUENCIA: "frequencia",
		Parametros.FASE: "fase",
		Parametros.AMPLITUDE: "amplitude",
		Parametros.PERIODO: "periodo",
	}
	
	if not (param in mapa):
		return ""
	
	return mapa[param]

func get_chave_parametro_ativo() -> String:
	return get_chave_parametro(parametro_ativo)

func get_valor_parametro_ativo():
	var chave = get_chave_parametro_ativo()
	if chave.is_empty():
		return
	
	return get(chave)
