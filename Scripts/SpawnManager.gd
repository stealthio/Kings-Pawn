extends Node2D

export var start_pos = Vector2(0,0)
export var cell_count = 8
export var spawn_count = Vector2(0,2) # a value between x..y
export var chance_to_spawn_per_round = 100

func _ready():
	Helper.game_manager.connect("on_turn_begin", self, "spawn_logic")

func spawn():
	var enemy = preload("res://Scenes/Enemy.tscn").instance()
	Helper.game_manager.get_node("Board").get_node("YSort").add_child(enemy)
	var tpos = start_pos + Vector2((int(rand_range(0,8)) * Helper.grid_size),0)
	if Helper.check_position(tpos) == Helper.cell_content.FREE:
		enemy.global_position = tpos
	else:
		enemy.call_deferred("free")

func spawn_logic():
	if rand_range(0, 100) < chance_to_spawn_per_round:
		for i in rand_range(spawn_count.x, spawn_count.y):
			spawn()
