extends Node2D

func set_up_figure(object, type):
	match(type):
		"Pawn":
			object.movement = [Vector2(0,1)]
			object.opener_movement = Vector2(0,2)
			object.killer_movement = Vector2(1,1)
			object.inversion = false
			object.addition = false
			object.endless = false
			object.move_can_kill = false
		"Bishop":
			object.movement = [Vector2(1,1)]
			object.opener_movement = Vector2(1,1)
			object.killer_movement = Vector2(0,0)
			object.inversion = false
			object.addition = false
			object.endless = true
			object.get_node("Sprite").texture = preload("res://Ressources/Figurines/Bishop.png")
		"Knight":
			object.movement = [Vector2(1,2)]
			object.opener_movement = Vector2(0,0)
			object.killer_movement = Vector2(0,0)
			object.inversion = true
			object.addition = false
			object.endless = false
			object.get_node("Sprite").texture = preload("res://Ressources/Figurines/Knight.png")
		"Rook":
			object.movement = [Vector2(1,0)]
			object.opener_movement = Vector2(1,0)
			object.killer_movement = Vector2(0,0)
			object.inversion = true
			object.addition = false
			object.endless = true
			object.get_node("Sprite").texture = preload("res://Ressources/Figurines/Rook.png")
		"Queen":
			object.movement = [Vector2(1,1),Vector2(1,0)]
			object.opener_movement = Vector2(0,0)
			object.killer_movement = Vector2(0,0)
			object.inversion = true
			object.addition = false
			object.endless = true
			object.get_node("Sprite").texture = preload("res://Ressources/Figurines/Queen.png")
		"King":
			object.movement = [Vector2(1,1)]
			object.opener_movement = Vector2(1,1)
			object.killer_movement = Vector2(0,0)
			object.inversion = false
			object.addition = true
			object.endless = false
			object.get_node("Sprite").texture = preload("res://Ressources/Figurines/King.png")
