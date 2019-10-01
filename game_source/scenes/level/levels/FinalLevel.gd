extends Node

const LEVEL_NAME = "Finished"

var intro_strings = [
"Servusssssss Dr Kindt",
"well done, you've found them all",
"we hope you enjoyed your adventure",
"from all of us at RCS",
"we want to wish you all the best!",
""
]

var string_index = 0
var level_complete = false

func _ready():
	$Player.position = Vector2(-200,20)
	$AnimationPlayer.play("WalkIn")
	$Player/AnimatedSprite.flip_h = false

func _physics_process(delta):
	if $Guide.ready == true && level_complete == false:
		if $Guide.busy() == false:
			if string_index < intro_strings.size():
				$Guide.say_string(intro_strings[string_index], 1)
				string_index += 1
				if string_index == 4:
					$Guide.delay(3)
			else:
				$Guide.stop_talking()
				$Guide.hide_item()
				level_finished()

func level_finished():
	level_complete = true
	$Guide/AnimationPlayer.play("WalkOut")