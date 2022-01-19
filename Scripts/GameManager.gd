extends Node2D

signal on_turn_begin
signal on_turn_end
signal victory
signal lose(reason)

var _player_turn = true # Prevents user interaction if not player turn

func _init():
	randomize()

# Spawn figures and set up winning condition (currently - all enemies dead)
func _ready():
	Helper.play_BGM(preload("res://Ressources/Music/BGM.wav"))
	spawn_figures()
	BoardEntities.connect("on_enemy_death", self, "_on_enemy_death")

# Iterates through all enemies to execute their "execute" function one after another. 
func execute_enemy_turn():
	yield(get_tree(), "idle_frame")
	for enemy in BoardEntities.get_enemies():
		enemy.execute()
		yield(enemy, "turn_finished")
	_player_turn = true
	emit_signal("on_turn_begin")

func is_player_turn():
	return _player_turn

func end_turn():
	_player_turn = false
	emit_signal("on_turn_end")
	execute_enemy_turn()

func check_victory():
	if Helper.current_difficulty == Helper.difficulty.INFINITE: # You can't win in infinite mode
		return
	if BoardEntities.get_enemies().size() <= 1: # check is with 1 as the enemy that has just been killed is still "Living" at this moment
		Helper.play_sound(preload("res://Ressources/SFX/winSound.mp3"), 1)
		emit_signal("victory")

func lose(reason):
	emit_signal("lose", reason)
	Helper.play_sound(preload("res://Ressources/SFX/loseSound.mp3"), 1)

# Takes all figures from Helper.figure_setup and places them in order on the board
func spawn_figures():
	var figure_setup = Helper.figure_setup
	for key in figure_setup:
		if figure_setup[key] == "":
			continue
		var figure = preload("res://Scenes/Figurine.tscn").instance()
		EntityTypes.set_up_figure(figure, figure_setup[key])
		$Board/YSort.add_child(figure)
		var xmod = key if key <= 8 else key - 8
		var ymod = 416 if key <= 8 else 416 + 64
		figure.position = Vector2(abs(64*(xmod - 1))+32, ymod)

func _on_enemy_death(enemy):
	check_victory()

