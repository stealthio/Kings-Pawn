extends Node

export var turns = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	Helper.game_manager.connect("on_turn_begin", self, "on_turn_begin")

func on_turn_begin():
	turns -= 1
	if turns <= 0:
		queue_free()
