extends Node2D

export var start_pos = Vector2(0,0)
export var cell_count = 8
export var spawn_count = [Vector2(0,2), Vector2(1,4), Vector2(3,6)] # a value between x..y
export var chance_to_spawn_per_round = [60,90,100]
export var possible_enemies = [[0],[0,1],[0,1]]
var enemies = [preload("res://Scenes/Enemy_Pawn.tscn"), preload("res://Scenes/Enemy_Archer.tscn")]
var difficulty = Helper.difficulty.EASY

func _ready():
	difficulty = Helper.current_difficulty
	Helper.game_manager.connect("on_turn_begin", self, "spawn_logic")
	yield(get_tree(), "idle_frame")
	for i in spawn_count[difficulty].y:
		spawn()

func spawn():
	var enemy = enemies[Helper.get_random_from_array(possible_enemies[difficulty])].instance()
	Helper.game_manager.get_node("Board").get_node("YSort").add_child(enemy)
	var tpos = start_pos + Vector2((int(rand_range(0,8)) * Helper.grid_size),0)
	if Helper.check_position(tpos) == Helper.cell_content.FREE:
		enemy.global_position = tpos
	else:
		enemy.die(true)

func spawn_logic():
	if rand_range(0, 100) < chance_to_spawn_per_round[difficulty]:
		for i in rand_range(spawn_count[difficulty].x, spawn_count[difficulty].y):
			spawn()
