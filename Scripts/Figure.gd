extends Node2D

export var movement = Vector2(0,1)
export var inversion = true # Allow the axis to be exchanged?
var selected = false setget setSelected
var _mouse_inside = false

func _ready():
	Helper.figures.append(self)

func setSelected(value):
	selected = value
	$Sprite.self_modulate = Color.aqua if selected else Color.white
	if selected:
		Helper.show_available_cells(global_position, movement, inversion, self)
	elif _mouse_inside:
		Helper.clear_available_cells()

func _process(delta):
	if Input.is_action_just_pressed("select"):
		if _mouse_inside:
			setSelected(!selected)
		else:
			setSelected(false)

func _on_Area2D_mouse_entered():
	_mouse_inside = true

func _on_Area2D_mouse_exited():
	_mouse_inside = false
