extends GridContainer

func _ready():
	BoardEntities.connect("on_enemy_death", self, "_add_killed_enemy")

func _add_killed_enemy(enemy):
	var tex = TextureRect.new()
	tex.texture = enemy.get_node("Sprite").texture
	tex.rect_min_size = Vector2(32,32)
	tex.expand = true
	tex.stretch_mode = TextureRect.STRETCH_KEEP
	add_child(tex)
