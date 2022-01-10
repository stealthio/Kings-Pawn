extends Node2D

export var movement = Array ([(Vector2(0,0)),])
export var opener_movement = Vector2(0,0)
export var killer_movement = Vector2(0,0)

export var inversion = true # Allow the axis to be exchanged?
export var addition = false # Allow the axis to be added to each other
export var endless = false # Allow the axis to be endless
var selected = false setget setSelected
var _mouse_inside = false
var _tpos = null
var _ppos = null
var _opener_used = false
var used = false

signal on_kill
signal on_death

func _ready():
	Helper.game_manager.figures.append(self)
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
		$AnimationPlayer.play("PickedUp")
	$Sprite.self_modulate = Color.aqua if selected else Color.white
	if selected:
		if !_opener_used and opener_movement != Vector2(0,0):
			Helper.show_available_cells(global_position, [opener_movement], inversion, addition, endless, self)
		else:
			Helper.show_available_cells(global_position, movement, inversion, addition, endless, self)
		
		# killer moves check
		if killer_movement != Vector2(0,0):
			Helper.show_available_cells(global_position, [killer_movement], inversion, addition, endless, self, true)
	elif _mouse_inside:
		$AnimationPlayer.play("PutDown")
		Helper.clear_available_cells()

func move_to_position(pos, end_turn = true):
	_tpos = pos
	_opener_used = true
	if end_turn:
		Helper.game_manager.end_turn()

func kill_at_position(pos):
	move_to_position(pos, false)
	used = true
	modulate = Color.darkblue
	emit_signal("on_kill", pos)

func _process(delta):
	if Input.is_action_just_pressed("select") and Helper.game_manager.is_player_turn:
		if _mouse_inside:
			setSelected(!selected)
		else:
			if selected:
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

func _on_Area2D_mouse_exited():
	_mouse_inside = false

func die():
	Helper.game_manager.figures.erase(self)
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
