extends Node

signal grandeza_alterada(grandeza: Grandeza)
signal menu_alterado(novo: MenuResource)
signal id_grandeza_sendo_editada_alterada()
signal tipo_de_onda_alterada()
signal digitacao_confirmada(mult: int)

enum ID_GRANDEZAS {
	NENHUM = 0,
	
	FREQUENCIA = 1,
	FASE = 2,
	AMPLITUDE = 3,
	PERIODO = 4,
	OFFSET = 5,
	SIMETRIA = 6,
}

enum ID_TIPO_ONDA {
	SIN = 1,
	QUAD = 2,
	TRIG = 3,
}

# a frequencia é a unica que muda seus limites, então achei melhor
# colocar as constantes apenas pra ela
const MAX_FREQ_SIN_QUAD = 25e6
const MAX_FREQ_TRIG = 500e3
const MIN_FREQ = 1e-6

var menu_atual: MenuResource = MenuPrincipal.new()
var menu_anterior: MenuResource

var frequencia := Grandeza.new(1e3, MIN_FREQ, MAX_FREQ_SIN_QUAD, 17, "hz")
var periodo := Grandeza.new(0, 40e-9, 1e6, 15, "s")
var fase := Grandeza.new(0, -360, 360, 9, "°")
var amplitude := Grandeza.new(5, 10e-3, 10, 8, "Vpp")
var offset := Grandeza.new(0, 0, 0, 8, "V")
var simetria := Grandeza.new(0, 0, 100, 8, "%")

var id_grandeza_sendo_editada: ID_GRANDEZAS = ID_GRANDEZAS.NENHUM:
	set(v):
		var antigo = id_grandeza_sendo_editada
		if antigo == v: return
		
		id_grandeza_sendo_editada = v
		id_grandeza_sendo_editada_alterada.emit()
		
var tipo_de_onda: ID_TIPO_ONDA = ID_TIPO_ONDA.SIN:
	set(v):
		var antigo = tipo_de_onda
		if antigo == v: return
		
		tipo_de_onda = v
		tipo_de_onda_alterada.emit()
		
		var max_freq = MAX_FREQ_TRIG if tipo_de_onda == ID_TIPO_ONDA.TRIG else MAX_FREQ_SIN_QUAD
		frequencia.set_limites(MIN_FREQ, max_freq)
		
func _ready() -> void:
	print("gerador ready")
	
	for grandeza: Grandeza in [frequencia, periodo, fase, amplitude, offset, simetria]:
		grandeza.alterado.connect(func(_a, _b): _grandeza_alterada(grandeza))
		
	#frequencia.valor = 1e6
	
# getters
func get_grandeza(id: ID_GRANDEZAS) -> Grandeza:
	match(id):
		ID_GRANDEZAS.FREQUENCIA:
			return frequencia
		ID_GRANDEZAS.FASE:
			return fase
		ID_GRANDEZAS.AMPLITUDE:
			return amplitude
		ID_GRANDEZAS.PERIODO:
			return periodo
		ID_GRANDEZAS.OFFSET:
			return offset
		ID_GRANDEZAS.SIMETRIA:
			return simetria
	
	return null

func get_grandeza_editada() -> Grandeza:
	return get_grandeza(id_grandeza_sendo_editada)

# setters
func set_grandeza_editada(id: ID_GRANDEZAS):
	id_grandeza_sendo_editada = id

func set_menu(menu: MenuResource) -> void:
	# verificar se os menus são os mesmos (hacky!!)
	if (menu_atual.get_script() == menu.get_script()): return
	if menu.reseta_grandeza_editada:
		id_grandeza_sendo_editada = ID_GRANDEZAS.NENHUM
	
	menu_anterior = menu_atual
	menu_atual = menu
	
	menu.ao_entrar()
	menu_alterado.emit(menu_atual)
	
# outros
func botao_pressionado(i: int) -> void:
	if (not menu_atual):
		#print_debug("botao_pressionado, porém menu_atual é nulo")
		return
		
	if (i >= menu_atual.botoes.size()):
		return
		
	if (not menu_atual.botoes[i].acao):
		#print_debug("esse botao não tem uma ação gng")
		return
	
	menu_atual.botoes[i].acao.call()
	
func _grandeza_alterada(grandeza: Grandeza):
	grandeza_alterada.emit(grandeza)
