extends Node2D

export var max_value = 32
var current_value = 0 setget set_current_value, get_current_value
onready var pointer = $Pointer
var selected_cell
signal on_value_changed

func _ready():
	Helper.play_BGM(preload("res://Ressources/Music/Castle_Theme.mp3"))
	var figure_setup = Helper.figure_setup
	var i = 1
	for child in $Slots.get_children():
		child.set_figurine(figure_setup[i])
		i += 1

func set_current_value(value):
	current_value = value
	emit_signal("on_value_changed", value)

func get_current_value():
	return current_value

func select_cell(cell):
	if selected_cell:
		selected_cell.modulate = Color.white
	selected_cell = cell
	selected_cell.modulate = Color.green

func draw_preview(figure):
	$Preview/Name.text = figure
	var figure_container = $Preview/Figures
	for child in figure_container.get_children():
		child.visible = false
	var n = figure_container.get_node_or_null(figure)
	if n:
		n.visible = true

func _on_Accept_pressed():
	if current_value > max_value:
		return
	Helper.play_sound(preload("res://Ressources/SFX/click.wav"), 0, -20)
	var slots = $Slots.get_children()
	var figures = {}
	for slot in slots:
		figures[slot.number + 1] = slot.figure
	Helper.figure_setup = figures
	get_tree().change_scene("res://Scenes/LevelSelect.tscn")

func _on_Clear_pressed():
	for slot in $Slots.get_children():
		if slot.editable:
			slot.set_figurine("")


func _on_Reset_pressed():
	for slot in $Slots.get_children():
		if slot.figure != "King":
			slot.set_figurine(slot.default)
