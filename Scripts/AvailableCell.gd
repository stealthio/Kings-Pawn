extends Sprite

var connected_figure
var _mouse_inside = false

func _process(delta):
	if Input.is_action_just_pressed("select"):
		if _mouse_inside:
			connected_figure.global_position = global_position
			Helper.clear_available_cells()



func _on_Area2D_mouse_entered():
	texture = preload("res://Ressources/Board/Available1.png")
	_mouse_inside = true


func _on_Area2D_mouse_exited():
	texture = preload("res://Ressources/Board/Available0.png")
	_mouse_inside = false
