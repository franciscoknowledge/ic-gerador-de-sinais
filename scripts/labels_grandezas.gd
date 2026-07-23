extends Node
signal fez_update

@onready var teclado = $"../teclado"

@onready var l_frequencia = $frequencia
@onready var l_periodo = $periodo
@onready var l_fase = $fase
@onready var l_amplitude = $amplitude
@onready var l_offset = $offset

# TODO: talvez tds esses dicts são ruins. outra hora procurar uma alternativa
@onready var label_para_grandeza: Dictionary[RichTextLabel, Grandeza] = {
	l_frequencia : Gerador.frequencia,
	l_periodo : Gerador.periodo,
	l_fase : Gerador.fase,
	l_amplitude : Gerador.amplitude,
	l_offset : Gerador.offset
}

@onready var label_para_texto: Dictionary[RichTextLabel, String] = {
	l_frequencia : "Freq",
	l_periodo : "Period",
	l_fase : "Phase",
	l_amplitude : "Ampl",
	l_offset : "Offset",
}

@onready var label_para_id: Dictionary[RichTextLabel, Gerador.ID_GRANDEZAS] = {
	l_frequencia : Gerador.ID_GRANDEZAS.FREQUENCIA,
	l_periodo : Gerador.ID_GRANDEZAS.PERIODO,
	l_fase : Gerador.ID_GRANDEZAS.FASE,
	l_amplitude : Gerador.ID_GRANDEZAS.AMPLITUDE,
	l_offset : Gerador.ID_GRANDEZAS.OFFSET,
}

var sufixos := {
	-9: "n",
	-6: "u",
	-3: "m",
	0: "",
	3: "k",
	6: "M",
	9: "G",
}

# TODO: adicionar um sinal para quando a posição do cursor muda
func _ready() -> void:
	update()
	Gerador.grandeza_alterada.connect(_on_grandeza_alterada)
	teclado.update.connect(update)

func get_notacao(grandeza: Grandeza) -> Dictionary:
	# tentando fazer de um jeito mais "estupido" pra nao ter erro com os floats
	var s = sign(grandeza.valor)
	var v = abs(grandeza.valor)
	var expoente: int = 0
	
	if v != 0:
		while v / 1000 >= 1:
			v /= 1000
			expoente += 3
			
		while v < 1:
			v *= 1000
			expoente -= 3
		
	var c = str(int(v))
		
	# TODO: esse padding com os digitos nn faz o minimo sentido pra nenhum outro parametro
	return {
		base = "%.*f" % [grandeza.digitos - 4 - c.length(), v * s],
		sufixo = sufixos[expoente],
		exp = expoente
	}

func inserir_cursor(string: String) -> String:
	return string.insert(teclado.pos_cursor, "│")
	
func get_base(grandeza: Grandeza) -> String:
	var params = get_notacao(grandeza)
	return params.base

func update() -> void:
	for label in label_para_grandeza:
		var grandeza = label_para_grandeza[label]
		var texto = label_para_texto[label]
		var id = label_para_id[label]
		
		var params = get_notacao(grandeza)
		var rect = label.get_node("rect")
		
		var valor_str: String
		if id == Gerador.id_grandeza_sendo_editada:
			rect.visible = true
		else:
			rect.visible = false
			
		var skip = texto.length() + 1
		var underline_i = teclado.pos_cursor + skip
		var underline_f = teclado.pos_cursor + skip + 4
		
		valor_str = "%s:%s %s%s" % [texto, params.base, params.sufixo, grandeza.unidade]
		if id == Gerador.id_grandeza_sendo_editada:
			if teclado.is_modo_digitacao:
				valor_str = "%s:%s" % [texto, inserir_cursor(teclado.string_edicao)]
			else:
				valor_str = valor_str.insert(underline_i, "[u]")
				valor_str = valor_str.insert(underline_f, "[/u]")
		
		label.text = valor_str
		
	fez_update.emit()
		
func _on_grandeza_alterada(_v) -> void:
	update()
