extends CanvasLayer

func _on_Restart_pressed():
	get_tree().reload_current_scene()


func _on_Setup_pressed():
	get_tree().change_scene("res://Scenes/TeamSetup.tscn")


func _on_Cancel_pressed():
	$Menu.visible = false
	
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		$Menu.visible = !$Menu.visible
