extends Node2D

export var max_value = 40
var current_value = 0 setget set_current_value, get_current_value

var selected_cell

signal on_value_changed

func set_current_value(value):
	current_value = value
	emit_signal("on_value_changed", value)

func get_current_value():
	return current_value

func select_cell(cell):
	if selected_cell:
		selected_cell.modulate = Color.white
	selected_cell = cell
	selected_cell.modulate = Color.red

func _on_Accept_pressed():
	if current_value > max_value:
		return
	var slots = $Slots.get_children()
	var figures = {}
	for slot in slots:
		figures[slot.number + 1] = slot.figure
	Helper.figure_setup = figures
	get_tree().change_scene("res://Game.tscn")