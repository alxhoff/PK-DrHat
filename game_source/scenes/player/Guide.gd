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

func show_item(item):
	$DisplayItem.visible = true
	var current_modulate = $DisplayItem.get_modulate()
	current_modulate.a = 255
	$DisplayItem.modulate = current_modulate
	$DisplayItem.set_texture(item)
	$DisplayItem/AnimationPlayer.play("ShakeGloves")

func show_gloves():
	$DisplayItem.set_texture(preload("res://sprites/items/Item__63.png"))
	$DisplayItem.visible = true
	$DisplayItem/AnimationPlayer.play("ShakeGloves")

	
func show_key():
	$DisplayItem.set_texture(preload("res://sprites/items/Item__68.png"))
	$DisplayItem/AnimationPlayer.play("GiveItem")
	$AudioStreamPlayer2D.set_stream(preload("res://audio/effects/magic.wav"))
	$AudioStreamPlayer2D.play(0)
	$DisplayItem.visible = true
