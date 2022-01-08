extends Node2D

func _ready():
	Helper.enemies.append(self)

func _exit_tree():
	Helper.enemies.erase(self)
