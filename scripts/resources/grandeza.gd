class_name Grandeza
extends Resource

signal alterado(novo: float, antigo: float)
signal limites_alterados
signal fez_clamp(excedeu: bool)

@export var valor_min: float = 0
@export var valor_max: float = 0
@export var digitos: int = 8
@export var unidade: String = ""

@export var valor: float = 0:
	set(v):
		var novo = clamp(v, valor_min, valor_max)
		
		if is_equal_approx(novo, valor): return
		var ocorreu_clamp = (v < valor_min or v > valor_max)
		var excedeu = (v > valor_max)
		
		var antigo = valor
		valor = novo
		alterado.emit(valor, antigo)
		if ocorreu_clamp:
			fez_clamp.emit(excedeu)
		
func _init(_valor: float, _min: float, _max: float, _digitos: int, _unidade: String) -> void:
	valor_min = _min
	valor_max = _max
	digitos = _digitos
	unidade = _unidade
	valor = _valor
	
func set_limites(_min: float, _max: float) -> void:
	valor_min = _min
	valor_max = _max
	
	limites_alterados.emit(_min, _max)
	valor = valor # forçar clamp se necessario
