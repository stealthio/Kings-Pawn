extends Node2D

var selected_difficulty = 0 # 0 == none; 1 == easy ...

func change_difficulty(value):
	selected_difficulty = value
	$PreviewPeasant.invis()
	$PreviewArcher.invis()
	$PreviewRogue.invis()
	if value >= 1:
		$PanelContainer3/ScrollContainer/HBoxContainer/Pawn.enable()
	else:
		$PanelContainer3/ScrollContainer/HBoxContainer/Pawn.disable()
	
	if value >= 2:
		$PanelContainer3/ScrollContainer/HBoxContainer/Archer.enable()
	else:
		$PanelContainer3/ScrollContainer/HBoxContainer/Archer.disable()
	
	if value >= 3:
		$PanelContainer3/ScrollContainer/HBoxContainer/Rogue.enable()
	else:
		$PanelContainer3/ScrollContainer/HBoxContainer/Rogue.disable()

func _on_Easy_pressed():
	Helper.play_sound(preload("res://Ressources/SFX/click.wav"))
	change_difficulty(1)
	Helper.current_difficulty = Helper.difficulty.EASY
	$Difficulty.text = "Easy"

func _on_Normal_pressed():
	Helper.play_sound(preload("res://Ressources/SFX/click.wav"))
	change_difficulty(2)
	Helper.current_difficulty = Helper.difficulty.NORMAL
	$Difficulty.text = "Normal"

func _on_Hard_pressed():
	Helper.play_sound(preload("res://Ressources/SFX/click.wav"))
	change_difficulty(3)
	Helper.current_difficulty = Helper.difficulty.HARD
	$Difficulty.text = "Hard"

func _on_Infinite_pressed():
	Helper.play_sound(preload("res://Ressources/SFX/click.wav"))
	change_difficulty(4)
	Helper.current_difficulty = Helper.difficulty.INFINITE
	$Difficulty.text = "Infinite"

func _on_Accept_pressed():
	if selected_difficulty != 0:
		get_tree().change_scene("res://Game.tscn")


func _on_Back_pressed():
	get_tree().change_scene("res://Scenes/TeamSetup.tscn")

