extends Sprite

var grid_size = 64 # used for movement patterns
var movement = Vector2(0,1)
var selected = false setget setSelected

func setSelected(value):
	selected = value
	self_modulate = Color.aqua if selected else Color.white

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			setSelected(!selected)
