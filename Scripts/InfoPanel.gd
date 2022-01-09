extends PanelContainer

var teamsetup 

func _ready():
	teamsetup = get_tree().root.get_node("TeamSetup")
	teamsetup.connect("on_value_changed", self, "on_value_changed")
	on_value_changed(teamsetup.current_value)

func on_value_changed(value):
	$Cost.text = "Total: " + String(value) + "/" + String(teamsetup.max_value)
	if value > teamsetup.max_value:
		$Cost.modulate = Color.red
	else:
		$Cost.modulate = Color.white
