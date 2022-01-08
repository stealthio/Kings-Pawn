extends Node2D

var _counter = Vector2(1,1)
var _grid_size = 64
export var game_size = Vector2(1,1)
export var offset = Vector2(32,32)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while _counter.y <= game_size.y :
		_counter.x = 1
		
		while _counter.x <= game_size.x :
			var s = Sprite.new()
			
			if int(_counter.x) %2 == 0 and int(_counter.y) %2 == 1: s.texture = preload("res://Ressources/Board/Black0.png")
			elif int(_counter.x) %2 == 1 and int(_counter.y) %2 == 0: s.texture = preload("res://Ressources/Board/Black0.png")
			else : s.texture = preload("res://Ressources/Board/White0.png")
			
			add_child(s)
			s.global_position = Vector2((_counter.x*_grid_size) + offset.x ,(_counter.y*_grid_size) + offset.y)	
				
			_counter.x += 1
			
		_counter.y += 1
