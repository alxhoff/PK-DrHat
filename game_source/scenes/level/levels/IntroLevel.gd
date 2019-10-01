extends Node

const LEVEL_NAME = "Intro"

var intro_strings = [
"Hello Philipp...", 
"I am Amla the mistress of riddles",
"And this is my side-kick yor",
"I seem to have lost my magic...", 
"...", 
"Much better", 
"Now we have prepared a challenge for you",
"And we have a number of delicious...", 
"#RIDDLESSSSS", 
"what you need to do Is collect", 
"all the hidden beacons",
"Each has its own fun sprite...", 
"For example this rejected paper...",
"",
"But to be honest the in-game sprite",
"Has absolutley nothing to",
"do with each beacon",
"At the end of it all is a shiny PhD...", 
"Or at least so I have been told...",
"Each riddle will tell you where to look",
"The signals from the becons seem to",
"be caught by ever changing means",
"You will have to use your wits to interpret",
"the signals",
"",
"Now take this and enjoy the advnture",
"",
"No wait stop...the first riddle",
"Ready?!?",
"",
"You work with me during the year.",
"I am the part of me for which",
"you do not care.",
"",
"Now go"
]

var string_index = 26
var level_complete = false

var paper_sprite = preload("res://sprites/items/Item__38.png")
var key_sprite = preload("res://sprites/items/Item__68.png")

func _ready():
	$Player/AnimatedSprite.flip_h = false
	
func _physics_process(delta):
	if $Guide.ready == true && level_complete == false:
		if $Guide.busy() == false:
			if string_index < intro_strings.size():
				$Guide.say_string(intro_strings[string_index], 1)
				string_index += 1
				if string_index == 5:
					$Guide.morph()
					$Guide.delay(2)
				if string_index == 14:
					$Guide.show_item(paper_sprite)
					$Guide.delay(2)
				if string_index == 15:
					$Guide.hide_item()
				if string_index == 27:
					$Guide.give_item(key_sprite)
					$Guide.delay(3)
					$Player.increment_items()
			else:
				$Guide.stop_talking()
				$Guide.hide_item()
				level_finished()
				
func level_finished():
	level_complete = true
	$Guide/AnimationPlayer.play("WalkOut")