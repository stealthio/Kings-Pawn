extends Node2D

var is_player_turn = true
var turn = 0
var figures = []
var enemies = []
var current_enemy

signal on_turn_end
signal on_turn_begin
signal on_enemy_pre_execute
signal on_enemy_added


func spawn_figures():
	var figure_setup = Helper.figure_setup
	for key in figure_setup:
		if figure_setup[key] == "":
			continue
		var figure = preload("res://Scenes/Figurine.tscn").instance()
		match(figure_setup[key]):
			"Pawn":
				figure.movement = [Vector2(0,1)]
				figure.opener_movement = Vector2(0,2)
				figure.killer_movement = Vector2(1,1)
				figure.inversion = false
				figure.addition = false
				figure.endless = false
			"Bishop":
				figure.movement = [Vector2(1,1)]
				figure.opener_movement = Vector2(1,1)
				figure.killer_movement = Vector2(0,0)
				figure.inversion = false
				figure.addition = false
				figure.endless = true
				figure.get_node("Sprite").texture = preload("res://Ressources/Figurines/Bishop.png")
			"Knight":
				figure.movement = [Vector2(1,2)]
				figure.opener_movement = Vector2(0,0)
				figure.killer_movement = Vector2(0,0)
				figure.inversion = true
				figure.addition = false
				figure.endless = false
				figure.get_node("Sprite").texture = preload("res://Ressources/Figurines/Knight.png")
			"Rook":
				figure.movement = [Vector2(1,0)]
				figure.opener_movement = Vector2(1,0)
				figure.killer_movement = Vector2(0,0)
				figure.inversion = true
				figure.addition = false
				figure.endless = true
				figure.get_node("Sprite").texture = preload("res://Ressources/Figurines/Rook.png")
			"Queen":
				figure.movement = [Vector2(1,1),Vector2(1,0)]
				figure.opener_movement = Vector2(0,0)
				figure.killer_movement = Vector2(0,0)
				figure.inversion = true
				figure.addition = false
				figure.endless = true
				figure.get_node("Sprite").texture = preload("res://Ressources/Figurines/Queen.png")
			"King":
				figure.movement = [Vector2(1,1)]
				figure.opener_movement = Vector2(1,1)
				figure.killer_movement = Vector2(0,0)
				figure.inversion = false
				figure.addition = true
				figure.endless = false
				figure.get_node("Sprite").texture = preload("res://Ressources/Figurines/King.png")
		$Board/YSort.add_child(figure)
		var xmod = key if key <= 8 else key - 8
		var ymod = 416 if key <= 8 else 416 + 64
		figure.position = Vector2(abs(64*(xmod - 1))+32, ymod)

func _init():
	randomize()

func _ready():
	spawn_figures()

func append_enemy(enemy):
	enemies.append(enemy)
	enemy.connect("on_death", self, "check_victory")
	emit_signal("on_enemy_added", enemy)

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

func restart():
	get_tree().reload_current_scene()

func check_victory(enemy):
	if enemies.empty():
		Helper.play_sound(preload("res://Ressources/SFX/winSound.wav"), 1)
		$UI/Victory.visible = true

func lose(reason):
	$UI/Lose.visible = true
	$UI/Lose/Reason.text = reason

func figure_setup():
	get_tree().change_scene("res://Scenes/TeamSetup.tscn")
