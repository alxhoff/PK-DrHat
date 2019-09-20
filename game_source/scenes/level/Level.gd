extends Node

enum LEVELS {
	INTRO = 0
	SEARCHING = 1
	OUTRO = 2
	FINISHED = 3
}

var current_level = LEVELS.INTRO

func _ready():
	pass

func _on_Player_level_completed():
	current_level += 1
	current_level = min(current_level, LEVELS.FINISHED)
	var current_level = $CurrentLevel
	remove_child(current_level)
	
	if current_level == LEVELS.SEARCHING:
		var next_level_resource = load("res://scenes/level/levels/ExploreLevel.tscn")
		var next_level = next_level_resource.instance()
		add_child(next_level)