extends Node

const INTRO = 1
const SEARCHING = 2
const INFO = 3
const OUTRO = 4
const FINISHED = 5

var current_level = INTRO

func _ready():
	pass


func _on_Player_level_completed():
	print("Handling level change")
	current_level = min(current_level, FINISHED)
	var current_level_node = $CurrentLevel
	remove_child(current_level_node)
	current_level_node.queue_free()
	var next_level = null
	
	if current_level == INTRO:
		var next_level_resource = load("res://scenes/level/levels/ExploreLevel.tscn")
		next_level = next_level_resource.instance()
		current_level = SEARCHING
		next_level.name = "CurrentLevel"
		add_child(next_level)
		
	elif current_level == SEARCHING:
		var next_level_resource = load("res://scenes/level/levels/ItemReceiveLevel.tscn")
		next_level = next_level_resource.instance()
		current_level = INFO
		next_level.name = "CurrentLevel"
		add_child(next_level)
		if get_parent().find_node("Items").item_count == 1:
			next_level.init("sword", "res://sprites/items/Item__07.png")
	
	elif current_level == INFO:
		pass
		
		
	
	