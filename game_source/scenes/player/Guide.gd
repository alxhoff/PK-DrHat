extends Node

var ready = true

func _ready():
	$SpeachBubble.set_flip_h(false)
	hide_item()
	pass

func say_string(string, delay):
	$SpeachBubble.say_text(string, delay)

func stop_talking():
	$SpeachBubble.show_text(false)

func busy():
	return $SpeachBubble.speaking
	
func morph():
	$AnimatedSprite/AnimationPlayer.play("Morph")
	$SpeachBubble.set_pitch_high(true)
	
func become_wizzard():
	$AnimatedSprite.play("Wizzard")
	
func delay(duration):
	ready = false
	$Timer.set_wait_time(duration)
	$Timer.start()

func _on_Timer_timeout():
	ready = true
	
func hide_item():
	$DisplayItem.visible = false

func give_item(item):
	$DisplayItem.visible = true
	$DisplayItem.set_texture(item)
	$DisplayItem/AnimationPlayer.play("GiveItem")

func show_item(item):
	$DisplayItem.set_texture(item)
	$DisplayItem.visible = true
	$DisplayItem/AnimationPlayer.play("ShakeGloves")

