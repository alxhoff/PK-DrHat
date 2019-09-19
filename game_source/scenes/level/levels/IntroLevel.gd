extends Node

signal key_given

var intro_strings = [
"Hello Philipp...", 
"I am Amla the mistress of riddles",
"but I seem to of lost my magic...", 
"...", 
"Much better", 
"Now we have prepared a challenge",
"And we have a number of delicious...", 
"RIDDLESSSSS for you", 
"#riddles",
"But what you really need to do", 
"Is collect all the hidden beacons",
"Each has its own fun open source sprite...", 
"For example this bad boy...",
"",
"At the end of it all is a shinny PhD...", 
"Or at least so I have been told.",
"Take this and enjoy the adventure",
""
]

var string_index = 0
var level_complete = false

func _ready():
	pass
	
func _physics_process(delta):
	print(string_index)
	if $Guide.ready == true && level_complete == false:
		if $Guide.busy() == false:
			if string_index < intro_strings.size():
				$Guide.say_string(intro_strings[string_index], 1)
				string_index += 1
				if string_index == 4:
					$Guide.morph()
					$Guide.delay(2)
				if string_index == 14:
					$Guide.show_gloves()
					$Guide.delay(2)
				if string_index == 15:
					$Guide.hide_item()
				if string_index == 18:
					$Guide.show_key()
					emit_signal("key_given")
					$Guide.delay(4)
			else:
				$Guide.stop_talking()
				$Guide.hide_item()
				level_finished()
				
func level_finished():
	level_complete = true
	$Guide/AnimationPlayer.play("LeaveScreen")
