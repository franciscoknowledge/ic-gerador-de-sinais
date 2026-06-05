@tool
extends Control

var plot_sin
var x = 0.0
var draw_enabled = false

# Parâmetros da onda
@export var amplitude: float = 1.0
@export var frequency: float = 0.1
@export var phase: float = 0.0
@export var offset: float = 0.0

func _ready():
	plot_sin = $Graph2D.add_plot_item("Wave", Color.YELLOW, 6)

#func _process(_delta):
#	if draw_enabled:
#		var y: float = amplitude * sin(TAU * frequency * x + phase) + offset
#		plot_sin.add_point(Vector2(x, y))
#		x += 0.02
#
#	if draw_enabled and x > $Graph2D.x_max:
#		draw_enabled = false

# Chame isso sempre que um parâmetro mudar (conecte aos seus sliders)
func redraw_wave():
	plot_sin.remove_all()
	x = 0.0
	draw_enabled = false

	var steps = 500
	for i in range(steps):
		var t = (float(i) / steps) * $Graph2D.x_max
		#var y = amplitude * sin(TAU * frequency * t + phase) + offset
		var y = sin(TAU * 0.2 * t + phase)
		plot_sin.add_point(Vector2(t, y))

func _on_draw_button_pressed():
	redraw_wave()

func _on_clear_button_pressed():
	draw_enabled = false
	plot_sin.remove_all()
	x = 0.0

# Conecte esses métodos aos sinais value_changed dos seus HSliders
func _on_amplitude_changed(value: float):
	amplitude = value
	redraw_wave()

func _on_frequency_changed(value: float):
	frequency = value
	redraw_wave()

func _on_phase_changed(value: float):
	phase = value
	redraw_wave()

func _on_offset_changed(value: float):
	offset = value
	redraw_wave()
