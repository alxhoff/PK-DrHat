extends Node

var ready = true

func _ready():
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

func show_gloves():
	$DisplayItem.set_texture(preload("res://sprites/items/Item__63.png"))
	$DisplayItem/AnimationPlayer.play("ShakeGloves")
	$DisplayItem.visible = true
	
func show_key():
	$DisplayItem.set_texture(preload("res://sprites/items/Item__69.png"))
	$DisplayItem/AnimationPlayer.play("ShakeGloves")
	$DisplayItem.visible = true
