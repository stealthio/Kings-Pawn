extends Node2D

export var movement = Array ([(Vector2(0,0)),])
export var opener_movement = Vector2(0,0)
export var killer_movement = Vector2(0,0)

export var endless = false # Allow the axis to be endless
export var endless_length = 8
export var move_can_kill = true #Allow for the normal movement to kill
var selected = false setget setSelected
var _mouse_inside = false
var _tpos = null
var _ppos = null
var _opener_used = false
var _cells = []

var used = false


signal on_kill
signal on_death

func _ready():
	BoardEntities.append_figure(self)
	Helper.game_manager.connect("on_turn_end", self, "on_turn_end")
	$AnimationPlayer.play("Idle")

func on_turn_end():
	used = false
	modulate = Color.white

func setSelected(value):
	if _tpos != null:
		return
	selected = value
	if selected:
		Helper.clear_available_cells()
		Helper.play_sound(preload("res://Ressources/SFX/click.wav"))
		$AnimationPlayer.play("PickedUp")
	$Sprite.self_modulate = Color.aqua if selected else Color.white
	if selected:
		show_available_cells()
	elif _mouse_inside:
		$AnimationPlayer.play("PutDown")
		clear_available_cells()

func move_to_position(pos, end_turn = true):
	_tpos = pos
	_opener_used = true
	Helper.play_sound(Helper.get_random_from_array([preload("res://Ressources/SFX/move1.wav"),preload("res://Ressources/SFX/move2.wav"),preload("res://Ressources/SFX/move3.wav")])  )
	if end_turn:
		Helper.game_manager.end_turn()

func kill_at_position(pos):
	move_to_position(pos, false)
	used = true
	modulate = Color(.25,.25,.25)
	emit_signal("on_kill", pos)

func _process(delta):
	if Input.is_action_just_pressed("select") and Helper.game_manager.is_player_turn():
		if _mouse_inside:
			setSelected(!selected)
		else:
			if selected:
				clear_available_cells()
				$AnimationPlayer.play("PutDown")
			setSelected(false)
	if _tpos:
		if global_position.distance_to(_tpos) > 1:
			global_position = lerp(global_position, _tpos, .2)
		else:
			global_position = _tpos
			_tpos = null

func _on_Area2D_mouse_entered():
	if !used:
		_mouse_inside = true
		Helper.play_sound(preload("res://Ressources/SFX/click.wav"))
		modulate = Color.darkgray

func _on_Area2D_mouse_exited():
	_mouse_inside = false
	if !used:
		modulate = Color.white

func die():
	Helper.play_sound(preload("res://Ressources/SFX/figureDeath.wav"))
	emit_signal("on_death", self)
	if $Sprite.texture == preload("res://Ressources/Figurines/King.png"):
		Helper.game_manager.lose("The king died!")
	Helper.shake_screen(10, 0.25, Vector2(1,1))
	call_deferred("free")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "PickedUp":
		$AnimationPlayer.play("FloatingIdle")
	if anim_name == "PutDown":
		$AnimationPlayer.play("RESET")
	if anim_name == "RESET":
		$AnimationPlayer.play("Idle")

func clear_available_cells():
	for cell in _cells:
		cell.queue_free()
	_cells.clear()

func _append_pos_if_free(arr, pos):
	if Helper.check_position(global_position + pos) == Helper.cell_content.FREE:
		arr.append(pos)

func show_available_cells():
	var positions = []
	for vector_to_show in movement:
		var base_direction = vector_to_show * Helper.grid_size
		var directions = []
		_append_pos_if_free(directions, base_direction)
		_append_pos_if_free(directions, -base_direction)
		
		if endless:
			var endless_positions = []
			for dir in directions:
				for x in endless_length:
					var t = dir * (x + 2) # Skip first 2 loops to avoid duplicates
					if Helper.check_position(global_position + t) != Helper.cell_content.FREE:
						break
					endless_positions.append(t)
			positions.append_array(endless_positions)
		
		positions.append_array(directions)

	for pos in positions:
		var cell = preload("res://Scenes/AvailableCell.tscn").instance()
		add_child(cell)
		cell.global_position = global_position + pos
		_cells.append(cell)
