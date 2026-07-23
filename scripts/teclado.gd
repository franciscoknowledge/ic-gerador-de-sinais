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

@export var is_modo_digitacao := false
@export var string_edicao := ""
@export var pos_cursor := 0

var grandeza: Grandeza

var grandeza_para_menu = {
	Gerador.ID_GRANDEZAS.FREQUENCIA: MenuUnidadesFreq.new(),
	Gerador.ID_GRANDEZAS.FASE: MenuUnidadesFase.new(),
	Gerador.ID_GRANDEZAS.AMPLITUDE: MenuUnidadesAmplitude.new(),
	Gerador.ID_GRANDEZAS.OFFSET: MenuUnidadesOffset.new(),
}

func _ready() -> void:
	for i in botoes_numeros.size():
		var botao: TextureButton = botoes_numeros[i]
		botao.pressed.connect(_bot_caractere.bind(str(i)))
		
	Gerador.id_grandeza_sendo_editada_alterada.connect(_set_grandeza)
	
	$cursor_tras.pressed.connect(mover_cursor.bind(-1))
	$cursor_frente.pressed.connect(mover_cursor.bind(1))
	$virgula.pressed.connect(_bot_caractere.bind("."))
	$sinal.pressed.connect(sinal)
	$backspace.pressed.connect(remover_caractere)
	$cancel.pressed.connect(cancel)
	$enter.pressed.connect(enter)
	
	Gerador.digitacao_confirmada.connect(_digitacao_confirmada)
	
	#Gerador.menu_alterado.connect(_menu_alterado)

func sai_dessa() -> void:
	pos_cursor = 0
	string_edicao = ""
	is_modo_digitacao = false
	
func aplicar() -> void:
	if not is_modo_digitacao: return
	if not grandeza: return
	
	grandeza.valor = float(string_edicao)
	sai_dessa()
	
func entrar_menu_unidades() -> void:
	if not grandeza_para_menu.has(Gerador.id_grandeza_sendo_editada): return
	Gerador.set_menu(grandeza_para_menu[Gerador.id_grandeza_sendo_editada])

func mover_cursor(dir: int) -> void:
	if not is_modo_digitacao: return
	if dir != -1 and dir != 1: return
	
	pos_cursor = clampi(pos_cursor + dir, 0, string_edicao.length())

func remover_caractere() -> void:
	if not is_modo_digitacao: return
	if string_edicao.is_empty(): return
	
	var pos = max(0, pos_cursor - 1)
	string_edicao = string_edicao.substr(0, pos) + string_edicao.substr(pos + 1)
	pos_cursor = max(0, pos_cursor - 1)

func inserir_caractere(chr: String) -> void:
	if not grandeza: return
	if not is_modo_digitacao: return
	
	if string_edicao.length() + 1 > grandeza.digitos:
		return
	
	var cursor_no_final = (pos_cursor == string_edicao.length())
	string_edicao = string_edicao.insert(pos_cursor, chr)
	
	if (cursor_no_final):
		pos_cursor += 1
		
func sinal() -> void:
	if not string_edicao.contains("-"):
		if string_edicao.length() + 1 > grandeza.digitos:
			return
			
		pos_cursor += 1
		string_edicao = string_edicao.insert(0, "-")
	else:
		pos_cursor -= 1
		string_edicao = string_edicao.erase(0, 1)
		
func enter() -> void:
	if not is_modo_digitacao: return
	
	Gerador.set_menu(Gerador.menu_anterior)
	aplicar()

func cancel() -> void:
	if not is_modo_digitacao: return
	
	Gerador.set_menu(Gerador.menu_anterior)
	sai_dessa()

func _bot_caractere(chr: String) -> void:
	var nao_repete = (chr == "." or chr == "-")
	if nao_repete and (string_edicao.contains(".") or string_edicao.contains("-")):
		return
	
	if not is_modo_digitacao:
		sai_dessa()
		is_modo_digitacao = true
		entrar_menu_unidades()
	
	inserir_caractere(chr)

func _set_grandeza() -> void:
	grandeza = Gerador.get_grandeza_editada()
	
	#if not grandeza:
	is_modo_digitacao = false
	sai_dessa()

func _digitacao_confirmada(mult: int) -> void:
	if not grandeza: return
	grandeza.valor = float(string_edicao) * pow(10, mult)
	sai_dessa()
