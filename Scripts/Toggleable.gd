extends Control

signal on_mouse_entered_enabled
signal on_mouse_exited_enabled

export var enabled = true

func enable():
	modulate = Color.white
	enabled = true
	
func disable():
	modulate = Color(0.1,0.1,0.1)
	enabled = false
	
func invis():
	visible = false
func vis():
	visible = true

func _ready():
	if !enabled:
		modulate = Color(0.1,0.1,0.1)
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")

func on_mouse_entered():
	if enabled:
		emit_signal("on_mouse_entered_enabled")

func on_mouse_exited():
	if enabled:
		emit_signal("on_mouse_exited_enabled")
