extends TextureRect

var y_min = -10
var y_max = 10
var spd = .05
var _default_pos
var _rising = true

func _ready():
	_default_pos = rect_global_position

func _process(delta):
	if _rising:
		rect_global_position = lerp(rect_global_position, _default_pos + Vector2(0,y_min), spd)
		if rect_global_position.distance_to(_default_pos + Vector2(0,y_min)) < 1:
			_rising = false
	else:
		rect_global_position = lerp(rect_global_position, _default_pos + Vector2(0,y_max), spd)
		if rect_global_position.distance_to(_default_pos + Vector2(0,y_max)) < 1:
			_rising = true

func move_to(position):
	_default_pos = position
