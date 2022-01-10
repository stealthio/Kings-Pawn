extends Node2D


func _on_Easy_pressed():
	Helper.play_sound(preload("res://Ressources/SFX/click.wav"))
	Helper.current_difficulty = Helper.difficulty.EASY
	get_tree().change_scene("res://Game.tscn")


func _on_Hard_pressed():
	Helper.play_sound(preload("res://Ressources/SFX/click.wav"))
	Helper.current_difficulty = Helper.difficulty.HARD
	get_tree().change_scene("res://Game.tscn")


func _on_Normal_pressed():
	Helper.play_sound(preload("res://Ressources/SFX/click.wav"))
	Helper.current_difficulty = Helper.difficulty.NORMAL
	get_tree().change_scene("res://Game.tscn")
