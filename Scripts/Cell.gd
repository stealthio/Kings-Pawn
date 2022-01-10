extends TextureButton

export var figure = ""
export var editable = true
export var number = 0
var tr
var teamsetup
var name_label

func _ready():
	teamsetup = get_tree().root.get_node("TeamSetup")
	_create_figurine(figure)
	if !editable:
		modulate = Color.darkgray
	name_label = get_parent().get_parent().get_node("PanelContainer/Name")
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")

func on_mouse_entered():
	Helper.play_sound(preload("res://Ressources/SFX/click.wav"))
	self_modulate = Color.red
	name_label.text = figure

func on_mouse_exited():
	self_modulate = Color.white
	name_label.text = ""

func _on_Available_pressed():
	if editable:
		Helper.play_sound(preload("res://Ressources/SFX/click.wav"))
		get_parent().get_parent().select_cell(self)

func set_figurine(figurine):
	teamsetup.current_value = teamsetup.current_value - Helper.get_figurine_value(figure) # substract previous used points
	figure = figurine
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

