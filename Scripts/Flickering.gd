extends Light2D

export var flicker_range = Vector2(-0.05,0.05)
export var flicker_duration = Vector2(1,5)
var _base_energy = 0
var _base_scale = Vector2(1,1)
var t
func _ready():
	_base_energy = energy
	_base_scale = scale
	t = Timer.new()
	t.connect("timeout", self, "flicker")
	t.one_shot = true
	add_child(t)
	t.start(rand_range(flicker_duration.x, flicker_duration.y))


func flicker():
	var flick = rand_range(flicker_range.x, flicker_range.y)
	energy = _base_energy + flick
	scale = _base_scale + Vector2(flick, flick)
	t.start(rand_range(flicker_duration.x, flicker_duration.y))

