extends Node2D

export var movement = Vector2(0,1)
export var attack : PoolVector2Array = []
export var move_on_kill = false
export var move_can_kill = true
export var ranged = false
var turn_done = false
var _tpos
var _dangerzone = []
var _mpos

signal on_kill
signal on_death

func _ready():
	Helper.game_manager.append_enemy(self)
	$AnimationPlayer.play("Appear")
	draw_dangerzone()
	
func die(without_animation = false):
	Helper.game_manager.enemies.erase(self)
	if without_animation:
		queue_free()
	else:
		emit_signal("on_death", self)
		$AnimationPlayer.play("Death")
		

func attack_pos(pos):
	if Helper.check_position(pos) == Helper.cell_content.ALLY:
		_mpos = pos
		$AnimationPlayer.play("Attack")
		return true
	return false

func move_to_position(pos):
	if Helper.check_position(pos) == Helper.cell_content.ENEMY:
		turn_done = true
		return
	if !move_can_kill:
		if Helper.check_position(pos) != Helper.cell_content.FREE:
			turn_done = true
			return
	Helper.play_sound(Helper.get_random_from_array([preload("res://Ressources/SFX/move1.wav"),preload("res://Ressources/SFX/move2.wav"),preload("res://Ressources/SFX/move3.wav")])  )
	# check for lose
	if pos.y > Helper.bottom_of_board:
		Helper.game_manager.lose("An enemy reached the castle!")
	_tpos = pos
	turn_done = true

func _process(delta):
	if _tpos:
		if global_position.distance_to(_tpos) > 1:
			global_position = lerp(global_position, _tpos, .2)
		else:
			global_position = _tpos
			_tpos = null

func execute():
	toggle_dangerzone(true)
	yield(get_tree().create_timer(.5), "timeout")
	# attack or move
	var attacked = false
	for vec in attack:
		if attack_pos(global_position + vec * Helper.grid_size):
			return
	if move_can_kill:
		if !attack_pos(global_position + movement * Helper.grid_size):
			move_to_position(global_position + movement * Helper.grid_size)
	else:
		move_to_position(global_position + movement * Helper.grid_size)
	draw_dangerzone()

func clear_dangerzone():
	for d in _dangerzone:
		d.call_deferred("free")
	_dangerzone.clear()

func _create_dz_at_pos(pos):
	var dz = Sprite.new()
	dz.texture = preload("res://Ressources/Board/Targeted.png")
	add_child(dz)
	_dangerzone.append(dz)
	dz.global_position = pos
	dz.visible = false
	return dz

func toggle_dangerzone(on):
	for dz in _dangerzone:
		dz.visible = on

func draw_dangerzone():
	clear_dangerzone()
	if move_can_kill:
		var t = global_position + movement * Helper.grid_size
		_create_dz_at_pos(t)
	# attack
	for vec in attack:
		var tp = global_position + vec * Helper.grid_size
		_create_dz_at_pos(tp)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Appear":
		$AnimationPlayer.play("Idle")
	if anim_name == "Death":
		queue_free()
	if anim_name == "Attack":
		Helper.get_figure_at_position(_mpos).die()
		if move_on_kill:
			move_to_position(_mpos)
		draw_dangerzone()
		emit_signal("on_kill", _mpos, ranged)
		turn_done = true

func on_squish():
	clear_dangerzone()
	Helper.play_sound(preload("res://Ressources/SFX/enemyDeath.wav"))
	Helper.shake_screen(10, 0.25, Vector2(1,1))


func _on_Area2D_mouse_entered():
	for dz in _dangerzone:
		dz.visible = true


func _on_Area2D_mouse_exited():
	for dz in _dangerzone:
		dz.visible = false
