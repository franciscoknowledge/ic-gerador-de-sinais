extends Node

const TEXTO_MAIOR = "%s não pode ser maior que %s"
const TEXTO_MENOR = "%s não pode ser menor que %s"

const SHIFT_Y = 32.0

@export var habilitado := true
var scene_notificacao = preload("res://cenas/notificacao.tscn")

func _ready() -> void:
	_init_sinais_gerador()

func reposicionar_y() -> void:
	var y = 0.0
	for existente in get_children():
		existente.position = Vector2(existente.position.x, y)
		y += SHIFT_Y

func _criar_notificacao(grandeza: Grandeza, excedeu: bool) -> void:
	if not habilitado: return
	
	var nome = Gerador.grandeza_para_nome[grandeza].capitalize()
	var notif: Notificacao = scene_notificacao.instantiate()
	
	var mensagem = TEXTO_MAIOR if excedeu else TEXTO_MENOR
	var valor_limite = grandeza.valor_max if excedeu else grandeza.valor_min
	
	var params = Engenharia.formatar_numero(valor_limite, 1)
	var numero_str = "%s%s%s" % [params.base, params.sufixo, grandeza.unidade]
	
	add_child(notif)
	
	notif.text = mensagem % [nome, numero_str]
	notif.centralizar_x()
	notif.animar()
	
	notif.desapareceu.connect(_on_desapareceu.bind(notif))
	reposicionar_y()

func _init_sinais_gerador() -> void:
	for grandeza in Gerador.grandeza_para_nome:
		grandeza.fez_clamp.connect(func(e): _criar_notificacao(grandeza, e))

func _on_desapareceu(notif: Notificacao) -> void:
	remove_child(notif)
	notif.queue_free()
	reposicionar_y()
