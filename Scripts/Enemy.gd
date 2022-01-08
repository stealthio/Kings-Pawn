extends Node2D

func _ready():
	Helper.enemies.append(self)

func _exit_tree():
	Helper.enemies.erase(self)

func die():
	$AnimationPlayer.play("Death")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		queue_free()
