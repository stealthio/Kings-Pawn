extends Label

var text_to_show = ""
var time_per_letter = 0.1
var fade_speed = .01

var timer
var fading = false

func show_text(t):
	text_to_show = t
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "on_timer_timeout")
	timer.start(time_per_letter)

func on_timer_timeout():
	if text_to_show == text:
		timer.stop()
		return
	else:
		if len(text_to_show) > 0:
			text = text + text_to_show[0]
			text_to_show = text_to_show.substr(1)
		else:
			timer.stop()
			return

func _process(delta):
	if fading:
		modulate.a -= fade_speed
		if modulate.a <= 0:
			queue_free()

func fade():
	fading = true
