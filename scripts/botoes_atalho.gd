extends Node

func _on_freq_periodo_pressed() -> void:
	Gerador.ir_para_menu(MenuFpp.new())

func _on_amplitude_alta_pressed() -> void:
	Gerador.ir_para_menu(MenuLa.new())
