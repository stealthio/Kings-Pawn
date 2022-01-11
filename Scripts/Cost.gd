extends Label

var teamsetup 

func _ready():
	teamsetup = get_tree().root.get_node("TeamSetup")
	teamsetup.connect("on_value_changed", self, "on_value_changed")
	on_value_changed(teamsetup.current_value)

func on_value_changed(value):
	text = "Total: " + String(value) + "/" + String(teamsetup.max_value)
	if value > teamsetup.max_value:
		modulate = Color.red
	else:
		modulate = Color.white
