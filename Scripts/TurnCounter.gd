extends Label

var turn = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	Helper.game_manager.connect("on_turn_begin", self, "turn_begin")
	Helper.game_manager.connect("on_turn_end", self, "turn_end")

func turn_begin():
	turn = turn+1
	text = "Turn: " + String(turn) + "\nPlayer phase"

func turn_end():
	text = "Turn: " + String(turn) + "\nEnemy phase"
