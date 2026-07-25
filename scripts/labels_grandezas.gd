extends Node
signal fez_update

@onready var teclado = $"../teclado"

@onready var l_frequencia = $frequencia
@onready var l_periodo = $periodo
@onready var l_fase = $fase
@onready var l_amplitude = $amplitude
@onready var l_offset = $offset

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

@onready var label_clones: Dictionary[RichTextLabel, RichTextLabel] = {}

func _ready() -> void:
	init_label_clones()
	update()
	Gerador.grandeza_alterada.connect(_on_grandeza_alterada)
	teclado.update.connect(update)

# HOLY HACKKKKKKKKKKKKKKKKKKKKKKK
# tenho que fazer desse jeito pq o underline nativo do godot é terrivel
func init_label_clones() -> void:
	var labels = [l_frequencia, l_periodo, l_fase, l_amplitude, l_offset]
	for label: RichTextLabel in labels:
		var clone = label.duplicate()
		clone.name = label.name + "_clone"
		clone.text = ""
		clone.add_theme_color_override("default_color", Color.BLACK)
		clone.position += Vector2(-2, 3.2)
		
		clone.get_node("rect").queue_free()
		clone.move_to_front()
		
		label_clones[label] = clone
		add_child(clone)

func inserir_cursor(string: String) -> String:
	return string.insert(teclado.pos_cursor, "│")

func update() -> void:
	for label in label_para_grandeza:
		var grandeza = label_para_grandeza[label]
		var texto = label_para_texto[label]
		var id = label_para_id[label]
		
		var params = Engenharia.formatar_grandeza(grandeza)
		var rect: ColorRect = label.get_node("rect")
		var clone: RichTextLabel = label_clones[label]
		
		var valor_str: String
		var skip = texto.length() + 1
		
		if id == Gerador.id_grandeza_sendo_editada:
			label.add_theme_color_override("default_color", Color.BLACK)
			rect.visible = true
		else:
			label.add_theme_color_override("default_color", Color.WHITE)
			clone.visible = false
			rect.visible = false
		
		valor_str = "%s:%s %s%s" % [texto, params.base, params.sufixo, grandeza.unidade]
		if id == Gerador.id_grandeza_sendo_editada:
			if teclado.is_modo_digitacao:
				valor_str = "%s:%s" % [texto, inserir_cursor(teclado.string_edicao)]
				clone.visible = false
			else:
				clone.text = " ".repeat(skip + teclado.pos_cursor) + "▁"
				clone.visible = true
		
		label.text = valor_str
		
	fez_update.emit()
		
func _on_grandeza_alterada(_v) -> void:
	update()
