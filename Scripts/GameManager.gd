extends Node2D

var is_player_turn = true
var turn = 0
var figures = []
var enemies = []
var current_enemy

signal on_turn_end
signal on_turn_begin
signal on_enemy_pre_execute

func _init():
	randomize()

func end_turn():
	is_player_turn = false
	for enemy in enemies:
		enemy.turn_done = false
	emit_signal("on_turn_end")

func _process(delta):
	if !is_player_turn:
		if !current_enemy and enemies.size() > 0:
			current_enemy = enemies[0]
			current_enemy.execute()
		elif !is_instance_valid(current_enemy):
			pass # Alle gegner tot
		elif current_enemy.turn_done:
			for enemy in enemies:
				if !enemy.turn_done:
					current_enemy = enemy
					emit_signal("on_enemy_pre_execute")
					current_enemy.execute()
					break
			if current_enemy.turn_done:
				emit_signal("on_turn_begin")
				is_player_turn = true
				current_enemy = null
