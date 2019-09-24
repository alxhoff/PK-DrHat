extends Node

var intro_strings = [
"Hello Philipp...", 
"I am Amla the mistress of riddles",
"but I seem to have lost my magic...", 
"...", 
"Much better", 
"Now we have prepared a challenge",
"And we have a number of delicious...", 
"#RIDDLESSSSS", 
"But what you really need to do", 
"Is collect all the hidden beacons",
"Each has its own fun open source sprite...", 
"For example this rejected paper...",
"",
"At the end of it all is a shiny PhD...", 
"Or at least so I have been told...",
"Take this and enjoy the adventure",
""
]

var string_index = 0
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
				if string_index == 4:
					$Guide.morph()
					$Guide.delay(2)
				if string_index == 13:
					$Guide.show_item(paper_sprite)
					$Guide.delay(2)
				if string_index == 14:
					$Guide.hide_item()
				if string_index == 17:
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