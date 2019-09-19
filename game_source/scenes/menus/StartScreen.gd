extends Node

func _ready():
	pass


func _on_StartButton_pressed():
	print("Clicked")
	get_tree().change_scene("res://scenes/World.tscn")
