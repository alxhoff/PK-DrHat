extends Node

const INTRO = 1
const SEARCHING = 2
const INFO = 3
const OUTRO = 4
const FINISHED = 5
const CREDITS = 6

var current_level = INTRO

var level_one_text = [
"I hide things",
"that you do not wish to keep.",
"To become a doctor",
"you have to dig deep"
]

var level_two_text = [
"Good ideas are hanging around,",
"indeed.",
"You have to think outside of the box",
"to proceed"
]

var level_three_text = [
"I am a treasure that you have found",
"today, I hide something that you need",
"to get crowned"
]

var level_four_text = [
"I have been exclusive to RCS members",
"with degrees.",
"come to me to share the same",
"ancestry"
]

var level_five_text = [
"you use me to share your knowledge",
"you find me and your doctorhood,",
"I acknowledge"
]

var level_six_text = [
"...",
"No wait silly me",
"we didn't have time for more",
"you've found them all!",
"...",
"the end?"
]

func _ready():
	pass
	
var explore_text = [
"Seems like my signal has a poor resolution",
"Looks like the duty cycle is improving",
"Looks like a strange light is signaling",
"What is that sound?!?!",
"Rise of the machines!",
"All systems go!"
]

func _on_Player_level_completed():
	current_level = min(current_level, CREDITS)
	var current_level_node = $CurrentLevel
	remove_child(current_level_node)
	current_level_node.queue_free()
	var next_level = null
	
	var ic = get_tree().get_root().get_node("World").find_node("Items").item_count
	var next_level_resource = null
	if current_level == INTRO or current_level == INFO:

		if ic == 7:
			next_level_resource = load("res://scenes/level/levels/FinalLevel.tscn") #TODO FINAL LEVEL
			next_level = next_level_resource.instance()
			current_level = FINISHED
		else:
			next_level_resource = load("res://scenes/level/levels/ExploreLevel.tscn")
			next_level = next_level_resource.instance()

			if ic == 0:
				next_level.init(ic, "Testing")  #Testing
			else:
				next_level.init(ic, explore_text[ic-1])
			current_level = SEARCHING

		add_child(next_level)
		
	elif current_level == SEARCHING:
		
		next_level_resource = load("res://scenes/level/levels/ItemReceiveLevel.tscn")
		current_level = INFO
		
		next_level = next_level_resource.instance()
		add_child(next_level)

		if ic == 1 or ic == 0:
			next_level.init("saucy sword", "res://sprites/items/Item__07.png", level_one_text)
		elif ic == 2:
			next_level.init("brilliant boots", "res://sprites/items/Item__50.png", level_two_text)
		elif ic == 3:
			next_level.init("great gloves", "res://sprites/items/Item__60.png", level_three_text)
		elif ic == 4:
			next_level.init("hot helmet", "res://sprites/items/Item__45.png", level_four_text)
		elif ic == 5:
			next_level.init("cheerful chest", "res://sprites/items/Item__59.png", level_five_text)
		elif ic == 6:
			next_level.init("PhD!", "res://sprites/items/Item__36.png", level_six_text)
			
	elif current_level == FINISHED:
		next_level_resource = load("res://scenes/level/levels/Credits.tscn")
		current_level = CREDITS
		next_level = next_level_resource.instance()
		add_child(next_level)
	next_level.name = "CurrentLevel"

func _on_UDPServer_new_bt_rssi(device, strength):
	var cur_level = $CurrentLevel
	if cur_level.LEVEL_NAME == "Explore":
		cur_level.set_signal(device, strength)

