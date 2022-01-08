extends Node2D

var grid_size = 64

var _temporary_cells = []

func clear_available_cells():
	for cell in _temporary_cells:
		cell.call_deferred("free")
	_temporary_cells.clear()

# Expects an actual position (e.g. 420, 69) and a relative movement vector (e.g. 1, 2) for the movable cells
# It will display a blue overlay at all the possible positions the player may move
func show_available_cells(origin_pos : Vector2, movement_vector : Vector2, object_reference):
	clear_available_cells()
	var possible_positions = [origin_pos + movement_vector * grid_size]
	if movement_vector.x != 0:
		possible_positions.append(origin_pos + Vector2(movement_vector.x * -1, movement_vector.y) * grid_size)
	if movement_vector.y != 0:
		possible_positions.append(origin_pos + Vector2(movement_vector.x, movement_vector.y * -1) * grid_size)
	if movement_vector.x + movement_vector.y != 0:
		possible_positions.append(origin_pos + Vector2(movement_vector.x * -1, movement_vector.y * -1) * grid_size)
	
	for pos in possible_positions:
		var s = preload("res://Scenes/AvailableCell.tscn").instance()
		_temporary_cells.append(s)
		s.connected_figure = object_reference
		get_tree().root.get_node("Game").add_child(s)
		s.global_position = pos
