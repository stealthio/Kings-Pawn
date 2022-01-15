extends Node2D

var _figures = []
var _obstacles = []
var _enemies = []

signal on_enemy_append(enemy)
signal on_enemy_kill(enemy, ranged, pos)
signal on_enemy_death(enemy)

signal on_obstacle_append(obstacle)

signal on_figure_append(figure)
signal on_figure_kill(figure)
signal on_figure_death(figure)

func append_enemy(enemy):
	_enemies.append(enemy)
	enemy.connect("on_death", self, "_enemy_died")
	enemy.connect("on_kill", self, "_enemy_kill")
	emit_signal("on_enemy_append", enemy)

func append_obstacle(obstacle):
	_obstacles.append(obstacle)
	emit_signal("on_obstacle_append", obstacle)

func append_figure(figure):
	_figures.append(figure)
	figure.connect("on_death", self, "_figure_died")
	figure.connect("on_kill", self, "_figure_kill")
	emit_signal("on_figure_append", figure)

func get_enemies():
	_enemies = _remove_freed_instances_from_array(_enemies)
	return _enemies

func get_obstacles():
	_obstacles = _remove_freed_instances_from_array(_obstacles)
	return _obstacles

func get_figures():
	_figures = _remove_freed_instances_from_array(_figures)
	return _figures

func _figure_died(figure):
	emit_signal("on_figure_death", figure)
	_figures.erase(figure)

func _figure_kill(figure):
	emit_signal("on_figure_kill", figure)

func _enemy_kill(enemy, ranged, pos):
	emit_signal("on_enemy_kill", enemy, ranged, pos)

func _enemy_died(enemy):
	emit_signal("on_enemy_death", enemy)
	_enemies.erase(enemy)

func _remove_freed_instances_from_array(arr):
	var return_value = []
	for element in arr:
		if element:
			if is_instance_valid(element):
				return_value.append(element)
	return return_value
			
	
