extends Node

var intro_strings = ["Hello Philipp", "....", "I am Amla the mistress of riddles",
"...I'm not feeling that pretty...", "...", "Much better!!"]

var string_index = 0

func _ready():
	pass
	
func _physics_process(delta):

	if $Guide.busy() == false && string_index < intro_strings.size():
		$Guide.say_string(intro_strings[string_index], 1.5)
		string_index += 1
	if string_index == 5:
		$AnimationPlayer.play("New Anim")
	pass