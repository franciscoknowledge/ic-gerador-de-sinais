extends Node

@onready var teclado = $"../teclado"

@onready var l_frequencia = $frequencia
@onready var l_periodo = $periodo
@onready var l_fase = $fase
@onready var l_amplitude = $amplitude
@onready var l_offset = $offset

# TODO: talvez tds esses dicts são ruins. outra hora procurar uma alternativa
@onready var label_para_grandeza: Dictionary[Label, Grandeza] = {
	l_frequencia : Gerador.frequencia,
	l_periodo : Gerador.periodo,
	l_fase : Gerador.fase,
	l_amplitude : Gerador.amplitude,
	l_offset : Gerador.offset
}

@onready var label_para_texto: Dictionary[Label, String] = {
	l_frequencia : "Freq",
	l_periodo : "Period",
	l_fase : "Phase",
	l_amplitude : "Ampl",
	l_offset : "Offset",
}

@onready var label_para_id: Dictionary[Label, Gerador.ID_GRANDEZAS] = {
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
	#Gerador.grandeza_alterada.connect(update)
	
func _process(_d) -> void:
	update()

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
		sufixo = sufixos[expoente]
	}

func inserir_cursor(string: String) -> String:
	return string.insert(teclado.pos_cursor, "|")

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
		
		valor_str = "%s:%s %s%s" % [texto, params.base, params.sufixo, grandeza.unidade]
		if id == Gerador.id_grandeza_sendo_editada and teclado.is_modo_digitacao:
			valor_str = "%s:%s" % [texto, inserir_cursor(str(teclado.string_edicao))]
		
		label.text = valor_str
		
		# tambem checar com teclado.is_modo_edicao
		#if id == Gerador.id_grandeza_sendo_editada:
		#	pass
		
		#var valor_str = str(grandeza.valor)
		#label.text = "%s:%s" % [texto, valor_str]
