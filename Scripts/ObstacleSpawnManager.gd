extends Node2D

export var obstacle_count = Vector2(1,4)

export var possible_positions :PoolVector2Array = []
var available_possible_positions = []

func _ready():
	for pos in possible_positions:
		available_possible_positions.append(pos)
	for i in int(rand_range(obstacle_count.x, obstacle_count.y)):
		spawn_obstacle()

func spawn_obstacle():
	var obstacle = Sprite.new()
	obstacle.texture = preload("res://Ressources/Board/Obstacle_Stone.png")
	obstacle.set_script(preload("res://Scripts/Obstacle.gd"))
	Helper.game_manager.get_node("Board/YSort").add_child(obstacle)
	if available_possible_positions.size() <= 0:
		return
	var pos = Helper.get_random_from_array(available_possible_positions)
	available_possible_positions.erase(pos)
	obstacle.position = pos
	

