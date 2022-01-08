extends Sprite

var connected_figure
var _mouse_inside = false
var type = Helper.cell_content.FREE

func check_position():
	type = Helper.check_position(global_position)
	match(type):
		Helper.cell_content.ALLY:
			self_modulate = Color.red
		Helper.cell_content.ENEMY:
			self_modulate = Color.green

func _process(delta):
	if Input.is_action_just_pressed("select"):
		if _mouse_inside:
			match(type):
				Helper.cell_content.FREE:
					connected_figure.move_to_position(global_position)
					Helper.clear_available_cells()
				Helper.cell_content.ENEMY:
					var enemy = Helper.get_enemy_at_position(global_position)
					enemy.die()
					connected_figure.kill_at_position(global_position)
					Helper.clear_available_cells()

func _on_Area2D_mouse_entered():
	texture = preload("res://Ressources/Board/Available1.png")
	_mouse_inside = true

func _on_Area2D_mouse_exited():
	texture = preload("res://Ressources/Board/Available0.png")
	_mouse_inside = false
