extends TextureButton

export var cost = 1
export var unit_name = "Pawn"
var teamsetup
var name_label
func _ready():
	teamsetup = get_tree().root.get_node("TeamSetup")
	$Cost.text = String(cost)
	name_label = get_parent().get_parent().get_parent().get_node_or_null("Name")
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")

func on_mouse_entered():
	Helper.play_sound(preload("res://Ressources/SFX/click.wav"))
	self_modulate = Color.aqua
	name_label.text = unit_name

func on_mouse_exited():
	self_modulate = Color.white
	name_label.text = ""

func _on_pressed():
	Helper.play_sound(preload("res://Ressources/SFX/click.wav"))
	if teamsetup.selected_cell:
		teamsetup.selected_cell.set_figurine(unit_name)
