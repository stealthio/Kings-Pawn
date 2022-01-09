extends Label

var turn = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	Helper.game_manager.connect("on_turn_begin", self, "new_turn")

func new_turn():
	turn = turn+1
	text = "Turn: " + String(turn)
