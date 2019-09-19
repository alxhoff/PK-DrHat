extends Node

func _ready():
	pass

func say_string(string, delay):
	$SpeachBubble.say_text(string, delay)

func busy():
	return $SpeachBubble.speaking
	
func become_wizzard():
	$AnimatedSprite.play("Wizzard")