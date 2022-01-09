extends GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	Helper.game_manager.connect("on_enemy_added", self, "on_new_enemy")

func on_new_enemy(enemy):
	enemy.connect("on_death", self, "add_killed_enemy", [enemy])

func add_killed_enemy(enemy):
	var tex = TextureRect.new()
	tex.texture = enemy.get_node("Sprite").texture
	tex.rect_min_size = Vector2(32,32)
	tex.expand = true
	tex.stretch_mode = TextureRect.STRETCH_KEEP
	add_child(tex)
