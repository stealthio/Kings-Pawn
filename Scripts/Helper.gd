extends Node2D

var grid_size = 64
var figures = []

var _temporary_cells = []

func clear_available_cells():
	for cell in _temporary_cells:
		cell.call_deferred("free")
	_temporary_cells.clear()

func _get_positions_from_vec(pos, vec, grid):
	var p = [pos + vec * grid]
	if vec.x != 0:
		p.append(pos + Vector2(vec.x * -1, vec.y) * grid)
	if vec.y != 0:
		p.append(pos + Vector2(vec.x, vec.y * -1) * grid)
	if vec.x != 0 and vec.y != 0:
		p.append(pos + Vector2(vec.x * -1, vec.y * -1) * grid)
	return p

# Expects an actual position (e.g. 420, 69) and a relative movement vector (e.g. 1, 2) for the movable cells
# It will display a blue overlay at all the possible positions the player may move
func show_available_cells(origin_pos : Vector2, movement_vector : Vector2, inversion: bool, object_reference):
	clear_available_cells()
	# Calculate all normal possible positions
	var possible_positions = _get_positions_from_vec(origin_pos, movement_vector, grid_size)
	
	# Calculate all inverted possible positions
	if inversion:
		movement_vector = Vector2(movement_vector.y, movement_vector.x)
		possible_positions.append_array(_get_positions_from_vec(origin_pos, movement_vector, grid_size))
	
	for pos in possible_positions:
		var s = preload("res://Scenes/AvailableCell.tscn").instance()
		_temporary_cells.append(s)
		s.connected_figure = object_reference
		get_tree().root.get_node("Game").add_child(s)
		s.global_position = pos
		s.check_position()

# check if a position is free
func check_position(position):
	for figure in figures:
		if figure.global_position == position:
			return false
	return true
