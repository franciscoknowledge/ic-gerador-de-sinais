extends Label

var str_formato = "Freq: %fhz\nFase: %f°\nAmp: %fV"

func _ready() -> void:
	Gerador.parametro_alterado.connect(_on_parametro_alterado)
	Gerador.cursor_movido.connect(_on_cursor_movido)
	_on_parametro_alterado("", null, null)

func _on_parametro_alterado(_parametro: String, _novo, _antigo):
	text = str_formato % [Gerador.frequencia, Gerador.fase, Gerador.amplitude]

func _on_cursor_movido():
	print(Gerador.parametro_posicao_cursor)
