extends Node2D

export var movement = Vector2(0,1)
export var attack : PoolVector2Array = []
export var move_on_kill = false
export var move_can_kill = true
export var ranged = false
var _tpos
var _dangerzone = []
var _mpos

signal on_kill(enemy, ranged, pos)
signal on_death
signal turn_finished

func _ready():
	BoardEntities.append_enemy(self)
	$AnimationPlayer.play("Appear")
	connect("turn_finished", self, "toggle_dangerzone", [false])
	connect("turn_finished", self, "draw_dangerzone")
	draw_dangerzone()
	
func die(without_animation = false):
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
	# Position blocked
	if Helper.check_position(pos) == Helper.cell_content.ENEMY or Helper.check_position(pos) == Helper.cell_content.OBSTACLE:
		# check for lose
		if pos.y > Helper.bottom_of_board:
			Helper.game_manager.lose("An enemy reached the castle!")
		# check left
		var left = global_position + Vector2(-Helper.grid_size,0)
		if Helper.check_position(left) == Helper.cell_content.FREE:
			move_to_position(left)
			return
		var right = global_position + Vector2(Helper.grid_size,0)
		if Helper.check_position(right) == Helper.cell_content.FREE:
			move_to_position(right)
			return
		emit_signal("turn_finished") # When the unit can neither move left or right
		return
	if !move_can_kill:
		if Helper.check_position(pos) != Helper.cell_content.FREE:
			return
	Helper.play_sound(Helper.get_random_from_array([preload("res://Ressources/SFX/move1.wav"),preload("res://Ressources/SFX/move2.wav"),preload("res://Ressources/SFX/move3.wav")])  )

	_tpos = pos
	emit_signal("turn_finished")

func _process(delta):
	if _tpos:
		if global_position.distance_to(_tpos) > 1:
			global_position = lerp(global_position, _tpos, .2)
		else:
			global_position = _tpos
			_tpos = null

func end_turn():
	emit_signal("turn_finished")

func execute():
	toggle_dangerzone(true)
	yield(get_tree().create_timer(.5), "timeout")
	
	# Create a timeout that will end turn after 10 seconds
	var timeout_timer = Timer.new()
	timeout_timer.connect("timeout", self, "end_turn")
	timeout_timer.connect("timeout", timeout_timer, "free")
	connect("turn_finished", timeout_timer, "free")
	add_child(timeout_timer)
	timeout_timer.start(10)

	# attack or move
	var attacked = false
	for vec in attack:
		if attack_pos(global_position + vec * Helper.grid_size):
			return
	if move_can_kill:
		if !attack_pos(global_position + movement * Helper.grid_size):
			move_to_position(global_position + movement * Helper.grid_size)
			return
		else:
			return
	else:
		move_to_position(global_position + movement * Helper.grid_size)
	emit_signal("turn_finished")

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
		emit_signal("on_kill", self, ranged, _mpos)
		emit_signal("turn_finished")

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
