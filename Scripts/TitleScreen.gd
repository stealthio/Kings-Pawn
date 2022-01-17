extends Node2D

enum States {
	STARTUP,
	IDLE,
	MENU
}

var state = States.STARTUP

func _ready():
	$AnimationPlayer.play("Startup")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Startup":
		state = States.IDLE
		$AnimationPlayer.playback_speed = 1
		$AnimationPlayer.play("Idle")

func _input(event):
	if event is InputEventMouseMotion: # Ignore Mouse motion
		return
	if state == States.STARTUP: # Speed up the beginning animation for impatient players
		$AnimationPlayer.playback_speed = 4
	elif state == States.IDLE:
		state = States.MENU
		$AnimationPlayer.play("ButtonPressed")


func _on_Start_Game_pressed():
	get_tree().change_scene("res://Scenes/TeamSetup.tscn")


func _on_Exit_pressed():
	get_tree().quit()


func _on_Discord_pressed():
	OS.shell_open("https://discord.gg/X5cEhz9yPf")


func _on_Itch_pressed():
	OS.shell_open("https://scarred95.itch.io/castle-chess")
