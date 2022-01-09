extends Node2D

export var movement = Vector2(0,1)
var turn_done = false
var _tpos

signal on_kill
signal on_death

func _ready():
	Helper.game_manager.enemies.append(self)
	$AnimationPlayer.play("Appear")
	
func die(without_animation = false):
	Helper.game_manager.enemies.erase(self)
	if without_animation:
		queue_free()
	else:
		emit_signal("on_death")
		$AnimationPlayer.play("Death")

func move_to_position(pos):
	_tpos = pos
	if Helper.check_position(pos) == Helper.cell_content.ALLY:
		Helper.get_figure_at_position(pos).die()
		emit_signal("on_kill", pos)

func _process(delta):
	if _tpos:
		if global_position.distance_to(_tpos) > .1:
			global_position = lerp(global_position, _tpos, .1)
		else:
			global_position = _tpos
			_tpos = null

func execute():
	modulate = Color.aqua
	yield(get_tree().create_timer(.5), "timeout")
	move_to_position(global_position + movement * Helper.grid_size)
	modulate = Color.white
	turn_done = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Appear":
		$AnimationPlayer.play("Idle")
	if anim_name == "Death":
		queue_free()
