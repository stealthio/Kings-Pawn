extends Node2D

export var start_pos = Vector2(0,0)
export var cell_count = 8
export var spawn_count = [Vector2(0,2), Vector2(1,3), Vector2(2,4)] # a value between x..y
export var chance_to_spawn_per_round = [60,90,100]
export var possible_enemies = [[0],[0,1],[0,1,2]]
var enemies = [preload("res://Scenes/Enemy_Pawn.tscn"), preload("res://Scenes/Enemy_Archer.tscn"), preload("res://Scenes/Enemy_Rogue.tscn")]
var difficulty = Helper.difficulty.EASY
var prepared_spawns = []

func _ready():
	difficulty = Helper.current_difficulty
	Helper.game_manager.connect("on_turn_begin", self, "spawn_logic")
	yield(get_tree(), "idle_frame")
	for i in spawn_count[difficulty].y:
		prepare_spawn()
	spawn()

func spawn():
	for prepared in prepared_spawns:
		if Helper.check_position(prepared.global_position) == Helper.cell_content.FREE:
			prepared.replace()
	prepared_spawns.clear()
	return
	var tpos = start_pos + Vector2((int(rand_range(0,8)) * Helper.grid_size),0)
	if Helper.check_position(tpos) == Helper.cell_content.FREE:
		var enemy = enemies[Helper.get_random_from_array(possible_enemies[difficulty])].instance()
		Helper.game_manager.get_node("Board").get_node("YSort").add_child(enemy)
		enemy.global_position = tpos

func prepare_spawn():
	var tpos = start_pos + Vector2((int(rand_range(0,8)) * Helper.grid_size),0)
	if Helper.check_position(tpos) == Helper.cell_content.FREE:
		for n in prepared_spawns:
			if n.global_position == tpos:
				return
		var enemy = enemies[Helper.get_random_from_array(possible_enemies[difficulty])].instance()
		var ps = Sprite.new()
		ps.texture = enemy.get_node("Sprite").texture
		ps.modulate = Color(.5,.4,1.0,.5)
		ps.set_script(preload("res://Scripts/Replacer.gd"))
		ps.with = enemy
		Helper.game_manager.get_node("Board").get_node("YSort").add_child(ps)
		ps.global_position = tpos
		prepared_spawns.append(ps)

func spawn_logic():
	spawn()
	if rand_range(0, 100) < chance_to_spawn_per_round[difficulty]:
		for i in rand_range(spawn_count[difficulty].x, spawn_count[difficulty].y):
			prepare_spawn()
