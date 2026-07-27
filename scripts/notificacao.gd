extends Label
class_name Notificacao

signal desapareceu()

const DUR_TRANSPARENCIA_S = 2.0
const DUR_SCALE_S = 0.2
const TIMER_S = 1.5

var animando = false
#var tween_transparencia: Tween

@onready var timer = $timer

func animar() -> void:
	centralizar_x()
	
	if animando: return
	animando = true
	
	var tween_scale = create_tween()
	
	scale = Vector2(0, 0)
	tween_scale.tween_property(self, "scale", Vector2(1, 1), DUR_SCALE_S).set_trans(Tween.TRANS_CIRC)
	
	timer.start()
	timer.timeout.connect(_fazer_tween_transparencia)
	
	#modulate = COR_INICIAL
	#_fazer_tween_transparencia()

func centralizar_x() -> void:
	var largura_tela = get_viewport_rect().size.x
	var largura_label = size.x
	
	position = Vector2((largura_tela - largura_label) / 2, position.y)
	pivot_offset = size / 2
	
func _fazer_tween_transparencia() -> void:
	if not animando: return
	var tween_transparencia = create_tween()
	
	var cor_alvo = Color(modulate.r, modulate.g, modulate.b, 0)
	
	tween_transparencia.tween_property(self, "modulate", cor_alvo, DUR_TRANSPARENCIA_S)
	tween_transparencia.finished.connect(desapareceu.emit)
