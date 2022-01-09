tool
extends Node2D


var _grid_size = 64
export var _game_size = Vector2(1,1) setget set_gamesize
export var offset = Vector2(32,32)


func set_gamesize(size: Vector2):
	_game_size = size
	for child in get_children():
		child.queue_free()
	build()

func build():
	var counter = Vector2(1,1)
	while counter.y <= _game_size.y :
		counter.x = 1
		
		while counter.x <= _game_size.x :
			var s = Sprite.new()
			
			if int(counter.x) %2 == 0 and int(counter.y) %2 == 1: s.texture = preload("res://Ressources/Board/Black0.png")
			elif int(counter.x) %2 == 1 and int(counter.y) %2 == 0: s.texture = preload("res://Ressources/Board/Black0.png")
			else : s.texture = preload("res://Ressources/Board/White0.png")
			
			add_child(s)
			s.global_position = Vector2((counter.x*_grid_size) + offset.x ,(counter.y*_grid_size) + offset.y)
				
			counter.x += 1
			
		counter.y += 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build()
