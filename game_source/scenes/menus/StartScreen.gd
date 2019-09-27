extends Node

func _ready():
	$MarginContainer/VBoxContainer/CenterContainer/StartButton/Sprite/AnimationPlayer.play("wiggle")
	pass

func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/level/World.tscn")
