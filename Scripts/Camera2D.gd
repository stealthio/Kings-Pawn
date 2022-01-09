extends Camera2D

export var maximum_movement_per_frame = 1
export var move = true

var baseoffset = Vector2(0,0)
var curr_shake = 0.0
var curr_duration = 0.0
var m_duration = 0.0
var m_shake = Vector2(0,0)
var direction = Vector2(0,0)
var shake_mod = 1

var tpos = Vector2()
var mpos = Vector2()

var _zoom_delta = 0.0
var _t_zoom = 0.0

func _ready():
	$Timer.connect("timeout", self, "_on_timer_timeout")

func shake_screen(intensity : float, duration : float = 1, dir : Vector2 = Vector2(0,0)):
	curr_shake = intensity
	m_shake = intensity
	m_duration = duration
	if(dir == Vector2(0,0)):
		dir = Vector2(randf(), randf())
	direction = dir
	$Timer.start(duration)

func _on_timer_timeout():
	curr_shake = 0
	direction = Vector2(0,0)

func _process(_delta):
	if($Timer.time_left > 0):
		var t_percentage =$Timer.time_left / m_duration
		curr_shake = m_shake * t_percentage
	else:
		curr_shake = 0

	if(randf() < 0.2):
		shake_mod = -shake_mod

	offset = (baseoffset + direction.normalized() * curr_shake * shake_mod).round()
