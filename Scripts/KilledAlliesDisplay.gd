extends GridContainer

func _ready():
	yield(get_tree(), "idle_frame")
	BoardEntities.connect("on_figure_death", self, "add_killed_ally")

func add_killed_ally(ally):
	var tex = TextureRect.new()
	tex.texture = ally.get_node("Sprite").texture
	tex.rect_min_size = Vector2(32,32)
	tex.expand = true
	tex.stretch_mode = TextureRect.STRETCH_KEEP
	add_child(tex)
