extends Area2D
class_name PotenciometroRotacao

signal rotacionado(rotacao: float, delta: float)

#@export var ANGULO_MAX = deg_to_rad(240)
#@export var ANGULO_MIN = deg_to_rad(-60)

const THRESHOLD_ROTACAO = 0.3
var rotacao_acumulada = 0
var selecionado = false

#func _ready() -> void:
#	rotation = ANGULO_MIN

func _process(_delta: float) -> void:
	if selecionado:
		arrastar()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not (event is InputEventMouseButton): return
	if event.button_index == MOUSE_BUTTON_LEFT:
		selecionado = event.is_pressed()

func _on_mouse_exited() -> void:
	selecionado = false
	
func arrastar() -> void:
	var anterior = rotation
	var angulo_mouse_potenciometro = get_global_mouse_position().angle_to_point(position)
	var angulo_suave = lerp_angle(rotation, angulo_mouse_potenciometro, 0.3)
	#angulo_suave = clamp(angulo_suave, ANGULO_MIN, ANGULO_MAX)
	rotation = angulo_suave
	
	var delta = rotation - anterior
	var s_acumulado = sign(rotacao_acumulada)
	var s_delta = sign(delta)
	
	if rotacao_acumulada != 0:
		if s_delta != s_acumulado:
			rotacao_acumulada = 0
			return
		
	rotacao_acumulada = rotacao_acumulada + delta
	if abs(rotacao_acumulada) < THRESHOLD_ROTACAO: return
	
	rotacao_acumulada = 0
	if anterior != rotation:
		rotacionado.emit(rotation, delta)
