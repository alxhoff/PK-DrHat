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
	current_level = min(current_level, FINISHED)
	var current_level_node = $CurrentLevel
	remove_child(current_level_node)
	current_level_node.queue_free()
	var next_level = null
	
	if current_level == INTRO or current_level == INFO:
		var next_level_resource = load("res://scenes/level/levels/ExploreLevel.tscn")
		next_level = next_level_resource.instance()
		current_level = SEARCHING
		next_level.name = "CurrentLevel"
		add_child(next_level)
		
	elif current_level == SEARCHING:
		var ic = get_parent().find_node("Items").item_count
		var next_level_resource = null
		if ic == 6:
			next_level_resource = load("res://scenes/level/levels/ItemReceiveLevel.tscn") #TODO FINAL LEVEL
			current_level = FINISHED
		else:
			next_level_resource = load("res://scenes/level/levels/ItemReceiveLevel.tscn")
			current_level = INFO
		
		next_level = next_level_resource.instance()
		next_level.name = "CurrentLevel"
		add_child(next_level)

		if ic == 1 or ic == 0:
			next_level.init("saucy sword", "res://sprites/items/Item__07.png")
		elif ic == 2:
			next_level.init("brilliant boots", "res://sprites/items/Item__50.png")
		elif ic == 3:
			next_level.init("great gloves", "res://sprites/items/Item__60.png")
		elif ic == 4:
			next_level.init("hot helmet", "res://sprites/items/Item__45.png")
		elif ic == 5:
			next_level.init("cheerful chest", "res://sprites/items/Item__59.png")
		
	
	

func _on_UDPServer_new_bt_rssi(device, strength):
	var cur_level = $CurrentLevel
	if cur_level.LEVEL_NAME == "Explore":
		cur_level.set_signal(device, strength)

