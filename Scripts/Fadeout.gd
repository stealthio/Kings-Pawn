extends Label

export var fadeout_start_after = 4.0
export var fadeout_speed = 0.01

var _fadeout = false

func _ready():
	var timer = Timer.new()
	timer.connect("timeout", self, "start_fadeout")
	add_child(timer)
	timer.start(fadeout_start_after)

func start_fadeout():
	_fadeout = true

func _process(delta):
	if _fadeout:
		modulate.a -= fadeout_speed
		if modulate.a <= 0:
			queue_free()

