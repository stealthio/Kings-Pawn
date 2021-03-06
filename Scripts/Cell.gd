extends TextureButton

export var figure = ""
export var editable = true
export var number = 0
export var active_on_start = false
var tr
var teamsetup
var name_label
var default = ""

func _ready():
	teamsetup = get_tree().root.get_node("TeamSetup")
	_create_figurine(figure)
	if !editable:
		modulate = Color("#222")
	name_label = get_parent().get_parent().get_node("Preview/Name")
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	if active_on_start:
		get_parent().get_parent().select_cell(self)
	default = figure

func on_mouse_entered():
	Helper.play_sound(preload("res://Ressources/SFX/click.wav"), 0, -20)
	self_modulate = Color.red
	teamsetup.draw_preview(figure)

func on_mouse_exited():
	self_modulate = Color.white
	teamsetup.draw_preview("")

func _on_Available_pressed():
	if editable:
		Helper.play_sound(preload("res://Ressources/SFX/click.wav"), 0, -20)
		get_parent().get_parent().select_cell(self)
		teamsetup.pointer.move_to(rect_global_position + Vector2(10, -40))

func set_figurine(figurine):
	teamsetup.current_value = teamsetup.current_value - Helper.get_figurine_value(figure) # substract previous used points
	figure = figurine
	teamsetup.current_value = teamsetup.current_value + Helper.get_figurine_value(figure)
	tr.texture = Helper.get_figurine_sprite(figure)


func _create_figurine(figurine):
	tr = TextureRect.new()
	tr.expand = true
	tr.rect_min_size = Vector2(64,64)
	tr.texture = Helper.get_figurine_sprite(figurine)
	teamsetup.current_value = teamsetup.current_value + Helper.get_figurine_value(figurine)
	add_child(tr)
	figure = figurine
	tr.rect_global_position = rect_global_position

