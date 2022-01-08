extends Node2D

var grid_size = 64

var game_manager = null

var _temporary_cells = []

enum cell_content {
	FREE,
	ALLY,
	ENEMY
}

func _ready():
	game_manager = get_tree().root.get_node("Game")

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
func show_available_cells(origin_pos : Vector2, movement_vector : Vector2, inversion: bool, addition: bool, endless: bool, object_reference):	
	# Calculate all normal possible positions
	var possible_positions = _get_positions_from_vec(origin_pos, movement_vector, grid_size)
	
	# Calculate all inverted possible positions
	if inversion and not endless:
		movement_vector = Vector2(movement_vector.y, movement_vector.x)
		possible_positions.append_array(_get_positions_from_vec(origin_pos, movement_vector, grid_size))
	
	if addition:
		var tmp_movement = movement_vector
		movement_vector = Vector2(tmp_movement.x, 0)
		possible_positions.append_array(_get_positions_from_vec(origin_pos, movement_vector, grid_size))
		movement_vector = Vector2(0,tmp_movement.y)
		possible_positions.append_array(_get_positions_from_vec(origin_pos, movement_vector, grid_size))
	
	if endless and not inversion:
		var tmp_movement = Vector2(movement_vector.x, movement_vector.y)
		var counter = 0
		while counter <= 50:
			possible_positions.append_array(_get_positions_from_vec(origin_pos, tmp_movement, grid_size))
			if tmp_movement.x !=0:
				tmp_movement.x +=1
			if tmp_movement.y !=0:
				tmp_movement.y +=1
			counter += 1
	
	if endless and inversion:
		var tmp_movement = movement_vector
		var counter = 1
		while counter <= 100:
			possible_positions.append_array(_get_positions_from_vec(origin_pos, tmp_movement, grid_size))
			tmp_movement =Vector2(tmp_movement.y, tmp_movement.x)
			possible_positions.append_array(_get_positions_from_vec(origin_pos, tmp_movement, grid_size))
			if tmp_movement.x !=0:
				tmp_movement.x +=1
			if tmp_movement.y !=0:
				tmp_movement.y +=1
			counter += 1
	
	for pos in possible_positions:
		var s = preload("res://Scenes/AvailableCell.tscn").instance()
		_temporary_cells.append(s)
		s.connected_figure = object_reference
		Helper.game_manager.add_child(s)
		s.global_position = pos
		s.check_position()
# check if a position is free
# returns 0 if free
# 1 if ally
# 2 if enemy
func check_position(position) -> int:
	for figure in Helper.game_manager.figures:
		if figure.global_position == position:
			return cell_content.ALLY
	for enemy in Helper.game_manager.enemies:
		if enemy.global_position == position:
			return cell_content.ENEMY
	return cell_content.FREE

func get_enemy_at_position(position):
	for enemy in Helper.game_manager.enemies:
		if enemy.global_position == position:
			return enemy
