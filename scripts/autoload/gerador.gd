extends Node

signal menu_alterado(novo: MenuResource)
signal parametro_alterado(parametro: String, novo, antigo)

enum Parametros {
	NENHUM = 0,
	
	FREQUENCIA = 1,
	FASE = 2,
	AMPLITUDE = 3,
}

var frequencia = 0:
	set(value):
		frequencia = value
		parametro_alterado.emit("frequencia", value, frequencia)
		
var fase = 0:
	set(value):
		fase = value
		parametro_alterado.emit("fase", value, fase)
		
var amplitude = 0:
	set(value):
		amplitude = value
		parametro_alterado.emit("amplitude", value, amplitude)
	
var cursor_parametro = 0

var menu_atual: MenuResource = MenuPrincipal.new()
var parametro_selecionado = Parametros.NENHUM

func _ready() -> void:
	menu_alterado.emit(menu_atual)

func ir_para_menu(menu: MenuResource) -> void:
	print("trocando menu")
	
	menu_atual = menu
	menu_alterado.emit(menu)
	
func botao_pressionado(indice: int) -> void:
	if (not menu_atual):
		print_debug("botao_pressionado, porém menu_atual é nulo")
		return
		
	if (indice > menu_atual.botoes.size() - 1): 
		print_debug("o indice é maior do que a lista de botões")
		return
	
	menu_atual.botoes[indice].acao.call()
## PLACEHOLDER
#func renderizar() -> void:
#	if (not menu_atual): return
#	
#	# TODO: implementar renderização
#	pass
