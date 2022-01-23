extends Node2D

var grid_size = 64
var bottom_of_board = 560
var current_difficulty = difficulty.EASY
var game_version = "0.9.220121"

var game_manager = null setget set_gamemanager, get_gamemanager

var temporary_cells = []

enum cell_content {
	FREE,
	ALLY,
	ENEMY,
	OBSTACLE
}

enum difficulty {
	EASY,
	NORMAL,
	HARD,
	INFINITE
}

var figure_setup = {
	1 : "Pawn",
	2 : "Pawn",
	3 : "Pawn",
	4 : "Pawn",
	5 : "Pawn",
	6 : "Pawn",
	7 : "Pawn",
	8 : "Pawn",
	9 : "Rook",
	10 : "Knight",
	11 : "Bishop",
	12 : "Queen",
	13 : "King",
	14 : "Bishop",
	15 : "Knight",
	16 : "Rook",
}

func clear_available_cell_duplicates():
	for cell in temporary_cells:
		if cell.freeing:
			continue
		for cell2 in temporary_cells:
			if cell2.global_position == cell.global_position and cell2 != cell:
				temporary_cells.erase(cell2)
				cell2.freeing = true
				cell2.queue_free()
	
func set_gamemanager(value):
	game_manager = value

func get_gamemanager():
	if !game_manager or !is_instance_valid(game_manager):
		game_manager = get_tree().root.get_node("Game")
	return game_manager

func _ready():
	game_manager = get_tree().root.get_node_or_null("Game")
	
	
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
		if is_instance_valid(cell):
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
	
func _get_positions_single_direction(pos, vec, grid):
	var p = [pos + vec * grid]
	return p
	
func _get_positions_endless(pos, vec, grid):
	var counter = 1
	var movement : Array
	while counter < 10:
		movement.append_array(_get_positions_single_direction(pos, Vector2(vec.x*counter, vec.y*counter), grid))
		if check_position(movement[movement.size()-1]) != 0:
			break 
		counter +=1
	return movement
	
func _calculate_positions_endless(origin_pos, movement_vector, grid_size):
	var possible_positions =[]
	if movement_vector.x !=0:
		possible_positions.append_array(_get_positions_endless(origin_pos, Vector2(movement_vector.x, movement_vector.y), grid_size))
		possible_positions.append_array(_get_positions_endless(origin_pos, Vector2((movement_vector.x*-1), movement_vector.y), grid_size))
		#Y vector up
	if movement_vector.y !=0:
		possible_positions.append_array(_get_positions_endless(origin_pos, Vector2(movement_vector.x, movement_vector.y), grid_size))
		possible_positions.append_array(_get_positions_endless(origin_pos, Vector2(movement_vector.x, (movement_vector.y*-1)), grid_size))
	# Doublevector up
	if movement_vector.y and movement_vector.x !=0:
		possible_positions.append_array(_get_positions_endless(origin_pos, Vector2(movement_vector.x, movement_vector.y), grid_size))
		possible_positions.append_array(_get_positions_endless(origin_pos, Vector2(movement_vector.x*-1, movement_vector.y*-1), grid_size))	
	return possible_positions
	
# Expects an actual position (e.g. 420, 69) and a relative movement vector (e.g. 1, 2) for the movable cells
# It will display a blue overlay at all the possible positions the player may move
func show_available_cells(origin_pos : Vector2, movement_array : Array, inversion: bool, addition: bool, endless: bool, object_reference, only_on_enemy : bool = false, move_can_kill : bool = true):	
	# Repeats the loop of every entry of the movement_array
	var possible_positions =[]
	for movement_vector in movement_array:
		possible_positions.append_array(_get_positions_from_vec(origin_pos, movement_vector, grid_size))
		# Calculate all normal possible positions
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
			possible_positions.append_array(_calculate_positions_endless(origin_pos, movement_vector, grid_size))
			if inversion:
				movement_vector =Vector2(movement_vector.y, movement_vector.x)
				possible_positions.append_array(_calculate_positions_endless(origin_pos, movement_vector, grid_size))
		if !move_can_kill:
			var arr = []
			for pos in possible_positions:
				if check_position(pos) == cell_content.ENEMY:
					arr.append(pos)
			for pos in arr:
				possible_positions.erase(pos)
	possible_positions= _remove_duplicates_from_array(possible_positions)
	for pos in possible_positions:
		var s = preload("res://Scenes/AvailableCell.tscn").instance()
		temporary_cells.append(s)
		s.connected_figure = object_reference
		get_gamemanager().add_child(s)
		s.global_position = pos
		s.check_position(only_on_enemy)
# check if a position is free
# returns 0 if free
# 1 if ally
# 2 if enemy
# 3 if obstacles
func check_position(position) -> int:
	for figure in BoardEntities.get_figures():
		if is_instance_valid(figure):
			if figure.global_position == position:
				return cell_content.ALLY
	for enemy in BoardEntities.get_enemies():
		if enemy.global_position == position:
			return cell_content.ENEMY
	for obstacle in BoardEntities.get_obstacles():
		if obstacle.global_position == position:
			return cell_content.OBSTACLE
	return cell_content.FREE

func get_figure_at_position(position):
	for figure in BoardEntities.get_figures():
		if figure.global_position == position:
			return figure

func get_enemy_at_position(position):
	for enemy in BoardEntities.get_enemies():
		if enemy.global_position == position:
			return enemy

func show_text_at_position(text, pos, duration = 3.0, color = Color.white):
	var label = Label.new()
	label.align = Label.ALIGN_CENTER
	label.set_script(preload("res://Scripts/DialogueLabel.gd"))
	label.add_font_override("font", preload("res://Ressources/Fonts/PixelFont.tres"))
	get_gamemanager().get_node("UI").add_child(label)
	label.rect_position = pos
	label.modulate = color
	var timer = Timer.new()
	label.add_child(timer)
	timer.connect("timeout", label, "fade")
	timer.start(duration)
	label.show_text(text)
	return label

func get_random_from_array(array):
	return array[randi() % array.size()]

func shake_screen(intensity : float, duration : float = 1, dir : Vector2 = Vector2(0,0)):
	get_gamemanager().get_node("Camera2D").shake_screen(intensity, duration, dir)

func get_figurine_sprite(figurine):
	match(figurine):
		"Pawn":
			return preload("res://Ressources/Figurines/Pawn.png")
		"Knight":
			return preload("res://Ressources/Figurines/Knight.png")
		"Bishop":
			return preload("res://Ressources/Figurines/Bishop.png")
		"Rook":
			return preload("res://Ressources/Figurines/Rook.png")
		"Queen":
			return preload("res://Ressources/Figurines/Queen.png")
		"King":
			return preload("res://Ressources/Figurines/King.png")
		"":
			return null

func get_figurine_value(figurine):
	match(figurine):
		"Pawn":
			return 0
		"Knight":
			return 3
		"Bishop":
			return 3
		"Rook":
			return 5
		"Queen":
			return 10
		"King":
			return 0
		"":
			return 0

func play_sound(sfx, channel = 0, db_mod = -10):
	var target = $SFX
	match(channel):
		1:
			target = $SFX2
	target.stream = sfx
	target.volume_db = db_mod
	target.play(0)

func play_BGM(bgm):
	if $BGM.stream != bgm:
		$BGM.stream = bgm
		$BGM.play(0)
	elif !$BGM.playing:
		$BGM.play(0)

func stop_BGM():
	$BGM.stop()

func toggle_BGM(value):
	if value:
		$BGM.volume_db = -10
	else:
		$BGM.volume_db = -999

func toggle_SFX(value):
	if value:
		$SFX.volume_db = -10
		$SFX2.volume_db = 0
	else:
		$SFX.volume_db = -999
		$SFX2.volume_db = -999
