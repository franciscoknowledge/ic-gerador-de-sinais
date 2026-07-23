extends Node

# coordenadas dos pontos na tela
const X_MIN = 140.0
const X_MAX = 570.0

const Y_MIN = 400.0
const Y_MAX = 630.0

# constantes para gerar uma onda com mesmas proporções
const FREQ = 0.025
const STEP = 1
const SIM = 50.0 # para triangulo

func _ready() -> void:
	gen()
	Gerador.tipo_de_onda_alterada.connect(gen)
	Gerador.grandeza_alterada.connect(_on_grandeza_alterada)
	
func _on_grandeza_alterada(grandeza: Grandeza) -> void:
	if grandeza != Gerador.fase: return
	gen()

func gen() -> void:
	$line.clear_points()
	
	# transformar o offset de -360 a 360 para -1 a 1
	var offset_fase = Gerador.fase.valor / 360.0
	
	var x_tela: float = X_MIN
	while x_tela <= X_MAX:
		# há uma separação entre o x e y usados nos calculos
		# e x, y na tela
		var x_matematico: float = x_tela - X_MIN
		var y_matematico = 0.0
		
		var valor_input = FREQ * x_matematico
		
		match Gerador.tipo_de_onda:
			Gerador.ID_TIPO_ONDA.SIN:
				y_matematico = calc_sin(valor_input, offset_fase)
			Gerador.ID_TIPO_ONDA.QUAD:
				y_matematico = calc_quad(valor_input, offset_fase)
			Gerador.ID_TIPO_ONDA.TRIG:
				y_matematico = calc_trig(valor_input, offset_fase, SIM)
		
		# y_matematico é invertido pq o godot aparentemente cresce no sentido
		# contrario
		var y_normalizado: float = (-y_matematico + 1.0) / 2.0
		var y_tela: float = lerp(Y_MIN, Y_MAX, y_normalizado)
		var y_final: float = clamp(y_tela, Y_MIN, Y_MAX) - 50
		
		$line.add_point(Vector2(x_tela, y_final))
		x_tela += STEP

func calc_sin(valor_entrada: float, offset_fase: float) -> float:
	var ciclo_normalizado: float = (valor_entrada / (2.0 * PI)) + offset_fase
	return sin(ciclo_normalizado * 2.0 * PI)

func calc_quad(valor_entrada: float, offset_fase: float) -> float:
	var ciclo_normalizado: float = (valor_entrada / (2.0 * PI)) + offset_fase
	
	var seno_base: float = sin(ciclo_normalizado * 2.0 * PI)
	return sign(seno_base)

func calc_trig(valor_entrada: float, offset_fase: float, simetria: float) -> float:
	var ciclo_normalizado: float = fposmod((valor_entrada / (2.0 * PI)) + offset_fase, 1.0)
	var ponto_simetria: float = clamp(simetria / 100.0, 0.01, 0.99)
	
	if ciclo_normalizado < ponto_simetria:
		return -1.0 + 2.0 * (ciclo_normalizado / ponto_simetria)
	else:
		return 1.0 - 2.0 * ((ciclo_normalizado - ponto_simetria) / (1.0 - ponto_simetria))
