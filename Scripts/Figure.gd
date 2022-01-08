extends Node2D

export var movement = Vector2(0,1)
export var inversion = true # Allow the axis to be exchanged?
var selected = false setget setSelected
var _mouse_inside = false
var _tpos = null
var _ppos = null

func _ready():
	Helper.figures.append(self)
	$AnimationPlayer.play("Idle")

func setSelected(value):
	selected = value
	if selected:
		$AnimationPlayer.play("PickedUp")
	$Sprite.self_modulate = Color.aqua if selected else Color.white
	if selected:
		Helper.show_available_cells(global_position, movement, inversion, self)
	elif _mouse_inside:
		$AnimationPlayer.play("PutDown")
		Helper.clear_available_cells()

func move_to_position(pos):
	_tpos = pos

func _process(delta):
	if Input.is_action_just_pressed("select"):
		if _mouse_inside:
			setSelected(!selected)
		else:
			if selected:
				$AnimationPlayer.play("PutDown")
			setSelected(false)
	if _tpos:
		if global_position.distance_to(_tpos) > .1:
			global_position = lerp(global_position, _tpos, .1)
		else:
			global_position = _tpos
			_tpos = null

func _on_Area2D_mouse_entered():
	_mouse_inside = true

func _on_Area2D_mouse_exited():
	_mouse_inside = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "PickedUp":
		$AnimationPlayer.play("FloatingIdle")
	if anim_name == "PutDown":
		$AnimationPlayer.play("RESET")
