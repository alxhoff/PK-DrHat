extends Node


const INTRO = 0
const SEARCHING = 1
const OUTRO = 2
const FINISHED = 3


var current_level = INTRO

func _ready():
	pass

func _on_Player_level_completed():
	current_level += 1
	current_level = min(current_level, FINISHED)
	var current_level_node = $CurrentLevel
	remove_child(current_level_node)
	current_level_node.queue_free()
	
	if current_level == SEARCHING:
		var next_level_resource = load("res://scenes/level/levels/ExploreLevel.tscn")
		var next_level = next_level_resource.instance()
		next_level.name = "CurrentLevel"
		add_child(next_level)