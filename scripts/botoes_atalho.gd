extends Node

func _ready() -> void:
	$freq_periodo.pressed.connect(atalho.bind(MenuFpp.new(), Gerador.ID_GRANDEZAS.FREQUENCIA))
	$amplitude_alta.pressed.connect(atalho.bind(MenuLa.new(), Gerador.ID_GRANDEZAS.AMPLITUDE))
	$fase_atraso.pressed.connect(atalho.bind(MenuFpp.new(), Gerador.ID_GRANDEZAS.FASE))
	$descolamento_baixo.pressed.connect(atalho.bind(MenuLa.new(), Gerador.ID_GRANDEZAS.OFFSET))

func atalho(menu: MenuResource, grandeza: Gerador.ID_GRANDEZAS) -> void:
	Gerador.set_menu(menu)
	Gerador.id_grandeza_sendo_editada = grandeza
