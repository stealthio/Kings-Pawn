extends Node2D

var turn_done = false

func _ready():
	Helper.game_manager.enemies.append(self)

func die():
	Helper.game_manager.enemies.erase(self)
	$AnimationPlayer.play("Death")

func execute():
	modulate = Color.blue
	yield(get_tree().create_timer(2), "timeout")
	modulate = Color.white
	turn_done = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		queue_free()
