# script mt ruim mas pelo menos funciona do jeito certo

extends Node
signal update()

@onready var labels_grandezas = $"../labels_grandezas"
@onready var potenciometro_rotacao = $"../potenciometro_rotacao"

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
	Gerador.digitacao_confirmada.connect(_digitacao_confirmada)
	
	$cursor_tras.pressed.connect(mover_cursor.bind(-1))
	$cursor_frente.pressed.connect(mover_cursor.bind(1))
	$virgula.pressed.connect(_bot_caractere.bind("."))
	$sinal.pressed.connect(_bot_sinal)
	$backspace.pressed.connect(remover_caractere)
	$cancel.pressed.connect(cancel)
	$enter.pressed.connect(enter)
	
	potenciometro_rotacao.rotacionado.connect(_on_potenciometro_rotacao)

func sai_dessa() -> void:
	pos_cursor = 0
	string_edicao = ""
	is_modo_digitacao = false
	update.emit()
	
func aplicar() -> void:
	if not is_modo_digitacao: return
	if not grandeza: return

	if not string_edicao.is_empty():
		grandeza.valor = float(string_edicao)
	sai_dessa()
	
	string_edicao = Engenharia.formatar_grandeza(grandeza).base
	
func entrar_menu_unidades() -> void:
	if not grandeza_para_menu.has(Gerador.id_grandeza_sendo_editada): return
	Gerador.set_menu(grandeza_para_menu[Gerador.id_grandeza_sendo_editada])

func mover_cursor(dir: int) -> void:
	if dir != -1 and dir != 1: return
	
	var pos_ponto = string_edicao.find(".")
	var pos_max = string_edicao.length()
	if not is_modo_digitacao:
		pos_max -= 1
	
	pos_cursor = clampi(pos_cursor + dir, 0, pos_max)
	
	if not is_modo_digitacao and pos_cursor == pos_ponto:
		pos_cursor += dir
	
	update.emit()
	
func remover_caractere() -> void:
	if not is_modo_digitacao: return
	if string_edicao.is_empty(): return
	
	var pos = max(0, pos_cursor - 1)
	string_edicao = string_edicao.substr(0, pos) + string_edicao.substr(pos + 1)
	pos_cursor = max(0, pos_cursor - 1)
	
	update.emit()

func inserir_caractere(chr: String) -> void:
	if not grandeza: return
	if not is_modo_digitacao: return
	
	if string_edicao.length() + 1 > grandeza.digitos:
		return
	
	var cursor_no_final = (pos_cursor == string_edicao.length())
	string_edicao = string_edicao.insert(pos_cursor, chr)
	
	if (cursor_no_final):
		pos_cursor += 1
		
	update.emit()
		
func sinal() -> void:
	if not is_modo_digitacao: return
	
	if not string_edicao.contains("-"):
		if string_edicao.length() + 1 > grandeza.digitos:
			return
			
		pos_cursor += 1
		string_edicao = string_edicao.insert(0, "-")
	else:
		pos_cursor -= 1
		string_edicao = string_edicao.erase(0, 1)
		
	update.emit()
		
func enter() -> void:
	if not is_modo_digitacao: return
	Gerador.set_menu(Gerador.menu_anterior)
	aplicar()

# edição pelo potenciometro
func modificar_casa(val: int) -> void:
	if val != 1 and val != -1: return
	if not grandeza: return
	if is_modo_digitacao: return
	if pos_cursor < 0 or pos_cursor >= string_edicao.length(): return
	if string_edicao[pos_cursor] == "." or string_edicao[pos_cursor] == "-": return
	
	var tem_sinal = string_edicao.begins_with("-")
	var primeiro_digito = 1 if tem_sinal else 0
	
	if pos_cursor == primeiro_digito:
		var atual = int(string_edicao[pos_cursor])
		if atual + val <= 0:
			return
			
	var numeros: Array[String] = []
	for i in range(string_edicao.length()):
		numeros.append(string_edicao[i])
		
	var carry = val
	var i = pos_cursor
	while carry != 0 and i >= 0:
		if numeros[i] == "." or numeros[i] == "-":
			i -= 1
			continue
			
		var n = int(numeros[i]) + carry
		if n > 9:
			n -= 10
			carry = 1
		elif n < 0:
			n += 10
			carry = -1
		else:
			carry = 0
		numeros[i] = str(n)
		i -= 1
	if carry < 0: return
	
	if carry > 0:
		if numeros.size() + 1 > grandeza.digitos:
			return
		var pos_insercao = 1 if tem_sinal else 0
		numeros.insert(pos_insercao, "1")
		pos_cursor += 1
		
	var params = Engenharia.formatar_grandeza(grandeza)
	var base = "".join(numeros)
	grandeza.valor = float(base) * pow(10, params.expoente)
	string_edicao = Engenharia.formatar_grandeza(grandeza).base
	
	var pos_ponto = string_edicao.find(".")
	
	if pos_cursor == pos_ponto:
		pos_cursor = pos_ponto - 1
		
	labels_grandezas.update()
	
func cancel() -> void:
	if not is_modo_digitacao: return
	
	Gerador.set_menu(Gerador.menu_anterior)
	sai_dessa()

func _bot_sinal() -> void:
	_iniciar_edicao_se_necessario()
	sinal()

func _bot_caractere(chr: String) -> void:
	var tem_ponto = is_modo_digitacao and string_edicao.contains(".")
	var tem_sinal = string_edicao.contains("-")
	if tem_ponto and chr == ".": return
	if tem_sinal and chr == "-": return
	
	_iniciar_edicao_se_necessario()
	inserir_caractere(chr)

func _set_grandeza() -> void:
	grandeza = Gerador.get_grandeza_editada()
	is_modo_digitacao = false
	sai_dessa()
	
	if not grandeza: return
	string_edicao = Engenharia.formatar_grandeza(grandeza).base

func _digitacao_confirmada(mult: int) -> void:
	if not grandeza: return
	grandeza.valor = float(string_edicao) * pow(10, mult)
	sai_dessa()
	string_edicao = Engenharia.formatar_grandeza(grandeza).base

func _iniciar_edicao_se_necessario() -> void:
	if is_modo_digitacao: return
	sai_dessa()
	is_modo_digitacao = true
	entrar_menu_unidades()
	update.emit()

func _on_potenciometro_rotacao(_rotacao: float, delta: float) -> void:
	var s = sign(delta)
	modificar_casa(s)
