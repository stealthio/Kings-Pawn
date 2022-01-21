extends Node2D

export var start_pos = Vector2(0,0)
export var cell_count = 8
export var spawn_count : PoolVector2Array = [Vector2(1,3), Vector2(2,3), Vector2(3,4), Vector2(1,5)] # a value between x..y
export var chance_to_spawn_per_round : PoolIntArray = [50,70,80,100]
export var possible_enemies = [[0],[0,1],[0,1,2], [0,1,2]]
export var difficulty_modifier_per_round = [1, 1, 1, 1.2]

var _current_difficulty_mod = 1
var enemies = [preload("res://Scenes/Enemy_Pawn.tscn"), preload("res://Scenes/Enemy_Archer.tscn"), preload("res://Scenes/Enemy_Rogue.tscn")]
var difficulty = Helper.difficulty.EASY
var prepared_spawns = []

func _ready():
	difficulty = Helper.current_difficulty
	Helper.game_manager.connect("on_turn_begin", self, "spawn_logic")
	Helper.game_manager.connect("on_turn_begin", self, "increase_difficulty")
	yield(get_tree(), "idle_frame")
	for i in spawn_count[difficulty].y:
		prepare_spawn(false)
	spawn()

func increase_difficulty():
	_current_difficulty_mod *= difficulty_modifier_per_round[difficulty]

func spawn():
	for prepared in prepared_spawns:
		if Helper.check_position(prepared.global_position) != Helper.cell_content.ENEMY:
			prepared.replace()
		if Helper.check_position(prepared.global_position) == Helper.cell_content.ALLY:
			Helper.get_figure_at_position(prepared.global_position).die()
	prepared_spawns.clear()

func prepare_spawn(with_warning = true):
	var tpos = start_pos + Vector2((int(rand_range(0,8)) * Helper.grid_size),0)
	if Helper.check_position(tpos) != Helper.cell_content.ENEMY:
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
		ps.z_index = -1
		prepared_spawns.append(ps)
		if !with_warning:
			return
		var warning = Sprite.new()
		warning.set_script(preload("res://Scripts/DeleteAfterTurns.gd"))
		warning.texture = preload("res://Ressources/Board/RedCell.png")
		Helper.game_manager.get_node("Board").get_node("YSort").add_child(warning)
		warning.global_position = tpos
		warning.z_index = -2
		

func spawn_logic():
	spawn()
	if rand_range(0, 100) < (chance_to_spawn_per_round[difficulty] * _current_difficulty_mod):
		for i in rand_range(int(spawn_count[difficulty].x * _current_difficulty_mod), int(spawn_count[difficulty].y * _current_difficulty_mod)):
			prepare_spawn()
