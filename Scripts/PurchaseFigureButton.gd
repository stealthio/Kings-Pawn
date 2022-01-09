extends TextureButton

export var cost = 1
export var unit_name = "Pawn"
var teamsetup
func _ready():
	teamsetup = get_tree().root.get_node("TeamSetup")
	$Cost.text = String(cost)

func _on_pressed():
	if teamsetup.selected_cell:
		teamsetup.selected_cell.set_figurine(unit_name)
		teamsetup.set_current_value(teamsetup.get_current_value() + cost)
