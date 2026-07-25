extends Node

# constantes para gerar uma onda com mesmas proporções
const FREQ = 0.036
const STEP = 4.0
const SIM = 50.0 # para triangulo

enum TIPO_LINHA {
	NENHUM = 0,
	
	PERIODO = 1,
	FASE = 2,
	PICO = 3,
}

@onready var background_grafico = $background_grafico

@onready var linha_grafico = $linha_grafico
@onready var linha_pico = $linha_pico
@onready var linha_periodo = $linha_periodo
@onready var linha_fase = $linha_fase

@onready var linha_x = $linha_x
@onready var linha_y = $linha_y

@onready var label_v_max = $eixo/max
@onready var label_v_mid = $eixo/mid
@onready var label_v_min = $eixo/min

@onready var label_pico = $"linha_pico/label"
@onready var label_periodo = $"linha_periodo/label"

@onready var label_eixo_tempo_sufixo = $"eixo_tempo/sufixo"
@onready var labels_eixo_tempo = [
	$"eixo_tempo/t0",
	$"eixo_tempo/t1",
	$"eixo_tempo/t2",
	$"eixo_tempo/t3",
	$"eixo_tempo/t4",
]

@onready var tipo_para_linha = {
	TIPO_LINHA.NENHUM: null,
	TIPO_LINHA.PERIODO: linha_periodo,
	TIPO_LINHA.FASE: linha_fase,
	TIPO_LINHA.PICO: linha_pico,
}

@onready var _y_tamanho = background_grafico.size * 0.8
@onready var _y_pos = background_grafico.position + _y_tamanho / 8

@onready var X_MIN: float = (background_grafico.position.x + 5)
@onready var X_MAX: float = (X_MIN + background_grafico.size.x - 9)

@onready var Y_MIN: float = (_y_pos.y)
@onready var Y_MAX: float = (Y_MIN + _y_tamanho.y)

@onready var BG_MAX: float = (background_grafico.position.y + background_grafico.size.y)

@onready var CENTRO_X: float = (X_MIN + X_MAX) / 2
@onready var CENTRO_Y: float = (Y_MIN + Y_MAX) / 2

func _ready() -> void:
	desenhar_grafico()
	
	linha_x.points = [Vector2(X_MIN, CENTRO_Y), Vector2(X_MAX, CENTRO_Y)]
	linha_y.points = [Vector2(CENTRO_X, Y_MIN), Vector2(CENTRO_X, Y_MAX)]
	
	set_linha_ativa(TIPO_LINHA.NENHUM)
	Gerador.tipo_de_onda_alterada.connect(desenhar_grafico)
	Gerador.grandeza_alterada.connect(_on_grandeza_alterada)
	Gerador.id_grandeza_sendo_editada_alterada.connect(_on_id_grandeza_sendo_editada_alterada)

func desenhar_grafico() -> void:
	linha_grafico.clear_points()
	
	# centro
	#var c_x: float = (X_MIN + X_MAX) / 2
	#var c_y: float = (Y_MIN + Y_MAX) / 2
	
	# offset -1 - 1
	var offset_fase: float = Gerador.fase.valor / 360
	
	# periodo em pixels
	var periodo_px: float = (2 * PI) / FREQ
	
	var deslocamento_px: float = offset_fase * periodo_px
	var x_zero: float = CENTRO_X - fposmod(deslocamento_px, periodo_px)
	
	var pico_x_tela: float = CENTRO_X
	var pico_y_tela: float = CENTRO_Y
	var pico_y_matematico: float
	
	var x_tela: float = X_MIN
	while x_tela <= X_MAX:
		# x_matematico vai de 0 a 1, é diferente das coordenadas em pixels de x_tela
		# mesma ideia para y_matematico
		var x_matematico: float = x_tela - CENTRO_X
		var y_matematico: float = 0
		
		var input = FREQ * x_matematico
		match Gerador.tipo_de_onda:
			Gerador.ID_TIPO_ONDA.SIN:
				y_matematico = calc_sin(input, offset_fase)
			Gerador.ID_TIPO_ONDA.QUAD:
				y_matematico = calc_quad(input, offset_fase)
			Gerador.ID_TIPO_ONDA.TRIG:
				y_matematico = calc_trig(input, offset_fase)
			
		var y_normalizado: float = (-y_matematico + 1.0) / 2.0
		var y_tela: float = lerp(Y_MIN, Y_MAX, y_normalizado)
		var y_final: float = clamp(y_tela, Y_MIN, Y_MAX)
		
		linha_grafico.add_point(Vector2(x_tela, y_final))
		if x_matematico >= 0.0 and x_matematico <= periodo_px and y_matematico > pico_y_matematico:
			pico_y_matematico = y_matematico
			pico_x_tela = x_tela
			pico_y_tela = y_final
		
		x_tela += STEP
		
	desenhar_linha_periodo(x_zero, periodo_px)
	desenhar_linha_pico(pico_x_tela, pico_y_tela)
	desenhar_eixo_tensao()
	desenhar_linha_fase()
	desenhar_tempo(periodo_px)

func calc_sin(valor_entrada: float, offset_fase: float) -> float:
	var ciclo_normalizado: float = (valor_entrada / (2.0 * PI)) + offset_fase
	return sin(ciclo_normalizado * 2.0 * PI)

func calc_quad(valor_entrada: float, offset_fase: float) -> float:
	var ciclo_normalizado: float = (valor_entrada / (2.0 * PI)) + offset_fase
	var seno_base: float = sin(ciclo_normalizado * 2.0 * PI)
	return sign(seno_base)

func calc_trig(valor_entrada: float, offset_fase: float) -> float:
	var ciclo_normalizado: float = fposmod((valor_entrada / (2.0 * PI)) + offset_fase, 1.0)
	var ponto_simetria: float = clamp(SIM / 100.0, 0.01, 0.99)

	if ciclo_normalizado < ponto_simetria:
		return -1.0 + 2.0 * (ciclo_normalizado / ponto_simetria)
	else:
		return 1.0 - 2.0 * ((ciclo_normalizado - ponto_simetria) / (1.0 - ponto_simetria))

func desenhar_linha_periodo(x_zero: float, periodo_px: float) -> void:
	var x_inicio = clamp(x_zero, X_MIN, X_MAX)
	var x_final: float = clamp(x_zero + periodo_px, X_MIN, X_MAX)
	
	var label_x = ((x_inicio + x_final) / 2) - (label_periodo.size.x / 4)
	var label_y = CENTRO_Y - label_periodo.size.y - 10
	
	linha_periodo.points = [Vector2(x_inicio, CENTRO_Y), Vector2(x_final, CENTRO_Y)]
	label_periodo.text = "1/f"
	label_periodo.position = Vector2(label_x, label_y)
	
	#var x_final = min(CENTRO_X + periodo_px, X_MAX)
	#
	#var label_x = ((CENTRO_X + x_final) / 2) - (label_periodo.size.x / 4)
	#var label_y = CENTRO_Y - label_periodo.size.y - 10
	#
	#linha_periodo.points = [Vector2(CENTRO_X, CENTRO_Y), Vector2(x_final, CENTRO_Y)]
	#label_periodo.text = "1/f"
	#label_periodo.position = Vector2(label_x, label_y)

func desenhar_linha_pico(pico_x: float, pico_y: float) -> void:
	linha_pico.points = [Vector2(pico_x, Y_MAX), Vector2(pico_x, pico_y)]

func desenhar_eixo_tensao() -> void:
	var amplitude_pico: float = Gerador.amplitude.valor / 2
	var offset: float = Gerador.offset.valor
	
	var y_max = Y_MIN
	var y_min = Y_MAX
	
	var labels = [label_v_max, label_v_mid, label_v_min] 
	var valores = [offset + amplitude_pico, offset, offset - amplitude_pico]
	for i in range(3):
		var l = labels[i]
		var v = valores[i]
		var params = Engenharia.formatar_numero(v, 2)
		
		l.text = "%s%sV" % [params.base, params.sufixo]
	
	#label_v_max.text = "%.2fV" % [(offset + amplitude_pico)]
	#label_v_mid.text = "%.2fV" % [offset]
	#label_v_min.text = "%.2fV" % [(offset - amplitude_pico)]
	
	# -99 é pra posicionar fora do gráfico
	label_v_max.position = Vector2(X_MIN - 99, y_max - label_v_max.size.y / 2)
	label_v_mid.position = Vector2(X_MIN - 99, CENTRO_Y - label_v_mid.size.y / 2)
	label_v_min.position = Vector2(X_MIN - 99, y_min - label_v_min.size.y / 2)
	
func desenhar_linha_fase() -> void:
	var x_final = remap(abs(Gerador.fase.valor), 0, 360, X_MIN, CENTRO_X)
	linha_fase.points = [Vector2(X_MIN + 2, CENTRO_Y), Vector2(x_final, CENTRO_Y)]
	
func desenhar_tempo(periodo_px: float) -> void:
								 # periodo = 1/f
	var tempo_por_pixel: float = (1/Gerador.frequencia.valor) / periodo_px
	var largura_total: float = X_MAX - X_MIN
	var divisoes = labels_eixo_tempo.size() - 1
	
	var tempo_max = largura_total * tempo_por_pixel
	var expoente = Engenharia.formatar_numero(tempo_max, 1).expoente
	
	for i in range(labels_eixo_tempo.size()):
		var x: float = X_MIN + (largura_total * i / divisoes)
		var tempo: float = (x - X_MIN) * tempo_por_pixel
		
		var label = labels_eixo_tempo[i]
		var params = Engenharia.formatar_numero_no_expoente(tempo, expoente, 1)
		
		label.text = "%s" % [params.base]#, params.sufixo]
		label.position = Vector2(x - label.size.x / 2, BG_MAX + 6)
		
	var suf_x = CENTRO_X - label_eixo_tempo_sufixo.size.x / 2
	var suf_y = BG_MAX + 40
	label_eixo_tempo_sufixo.position = Vector2(suf_x, suf_y)
	label_eixo_tempo_sufixo.text = "%ss" % [Engenharia.get_sufixo(expoente)]
	#print(label_eixo_tempo_sufixo.position)

func set_linha_ativa(tipo: TIPO_LINHA) -> void:
	for val in TIPO_LINHA.values():
		var linha: Line2D = tipo_para_linha[val]
		if not linha: continue
		
		if val == tipo:
			linha.visible = true
		else:
			linha.visible = false

func _on_grandeza_alterada(_grandeza: Grandeza) -> void:
	desenhar_grafico()
	
func _on_id_grandeza_sendo_editada_alterada() -> void:
	match Gerador.id_grandeza_sendo_editada:
		Gerador.ID_GRANDEZAS.FREQUENCIA:
			set_linha_ativa(TIPO_LINHA.PERIODO)
		Gerador.ID_GRANDEZAS.FASE:
			set_linha_ativa(TIPO_LINHA.FASE)
		Gerador.ID_GRANDEZAS.AMPLITUDE:
			set_linha_ativa(TIPO_LINHA.PICO)
		_:
			set_linha_ativa(TIPO_LINHA.NENHUM)
