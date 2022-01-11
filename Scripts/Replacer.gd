extends Node2D


var with

func replace():
	assert(with != null)
	var new_node = with
	get_parent().add_child(new_node)
	new_node.global_position = global_position
	queue_free()
