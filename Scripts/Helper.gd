extends Node2D

var grid_size = 64

var game_manager = null

var temporary_cells = []

enum cell_content {
	FREE,
	ALLY,
	ENEMY
}

func _ready():
	game_manager = get_tree().root.get_node("Game")
	
func _remove_duplicates_from_array (array_with_dupes : Array):
	var array_no_dupes = []
	var array_dupes =[]
	var finished_array = []
	var i = 0
	var j = 0
	for pos in array_with_dupes:
		var duplicated = false
		j = 0
		for pos2 in array_with_dupes:
			if pos == pos2 and i!=j:
				duplicated = true
				break
			j +=1
		if not duplicated:
			array_no_dupes.append(pos)
		else:
			if array_dupes.find(pos) == -1:
				array_dupes.append(pos)
		i +=1
	finished_array = array_no_dupes
	finished_array.append_array(array_dupes)
	return finished_array

func clear_available_cells():
	for cell in temporary_cells:
		cell.call_deferred("free")
	temporary_cells.clear()

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
func show_available_cells(origin_pos : Vector2, movement_array : Array, inversion: bool, addition: bool, endless: bool, object_reference, only_on_enemy : bool = false):	
	# Repeats the loop of every entry of the movement_array
	for movement_vector in movement_array:
		# Calculate all normal possible positions
		var possible_positions = _get_positions_from_vec(origin_pos, movement_vector, grid_size)
		# Calculate all inverted possible positions
		if inversion:
			movement_vector = Vector2(movement_vector.y, movement_vector.x)
			possible_positions.append_array(_get_positions_from_vec(origin_pos, movement_vector, grid_size))
		# adds the different movement options with the given X and Y movement's together
		if addition:
			var tmp_movement = movement_vector
			movement_vector = Vector2(tmp_movement.x, 0)
			possible_positions.append_array(_get_positions_from_vec(origin_pos, movement_vector, grid_size))
			movement_vector = Vector2(0,tmp_movement.y)
			possible_positions.append_array(_get_positions_from_vec(origin_pos, movement_vector, grid_size))
		# adds infinite movement in the given directions
		if endless:
			var counter = 2
			while counter <= 8:
				possible_positions.append_array(_get_positions_from_vec(origin_pos, movement_vector*counter, grid_size))
				if inversion:
					movement_vector =Vector2(movement_vector.y, movement_vector.x)
					possible_positions.append_array(_get_positions_from_vec(origin_pos, movement_vector*counter, grid_size))
				counter += 1
		
		possible_positions= _remove_duplicates_from_array(possible_positions)


		for pos in possible_positions:
			var s = preload("res://Scenes/AvailableCell.tscn").instance()
			temporary_cells.append(s)
			s.connected_figure = object_reference
			Helper.game_manager.add_child(s)
			s.global_position = pos
			s.check_position(only_on_enemy)
	
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

func get_figure_at_position(position):
	for figure in Helper.game_manager.figures:
		if figure.global_position == position:
			return figure

func get_enemy_at_position(position):
	for enemy in Helper.game_manager.enemies:
		if enemy.global_position == position:
			return enemy
