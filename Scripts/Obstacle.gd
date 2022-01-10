extends Node2D

func _ready():
	Helper.game_manager.obstacles.append(self)
