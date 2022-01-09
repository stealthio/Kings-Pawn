extends Node2D


export var opening_dialogue_chance = 10
export var opening_dialogues : PoolStringArray = []
export var kill_dialogues: PoolStringArray = []
export var death_dialogues: PoolStringArray = []

func _ready():
	get_parent().connect("on_kill", self, "on_kill")
	get_parent().connect("on_death", self, "on_death")
	if rand_range(0, 100) <= opening_dialogue_chance:
		Helper.show_text_at_position(Helper.get_random_from_array(opening_dialogues), get_parent().global_position)

func on_death():
	Helper.show_text_at_position(Helper.get_random_from_array(death_dialogues), get_parent().global_position)

func on_kill(pos):
	Helper.show_text_at_position(Helper.get_random_from_array(kill_dialogues), pos + Vector2(-40,-40))
