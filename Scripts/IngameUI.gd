extends CanvasLayer

func _ready():
	Helper.game_manager.connect("on_turn_begin", self, "_on_turn_begin")
	Helper.game_manager.connect("on_turn_end", self, "_on_turn_end")
	Helper.game_manager.connect("victory", self, "_on_victory")
	Helper.game_manager.connect("lose", self, "_on_lose")

func _on_Restart_pressed():
	get_tree().reload_current_scene()

func _on_Setup_pressed():
	get_tree().change_scene("res://Scenes/TeamSetup.tscn")


func _on_Cancel_pressed():
	$Menu.visible = false
	
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		$Menu.visible = !$Menu.visible

func _on_turn_begin():
	$EndTurn.disabled = false

func _on_turn_end():
	$EndTurn.disabled = true

func _on_victory():
	$Victory.visible = true

func _on_lose(reason):
	$Lose.visible = true
	$Lose/Reason.text = reason
