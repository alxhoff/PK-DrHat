extends Node

const LEVEL_NAME = "Explore"

func _ready():
	$Player.position = Vector2(-200,37)
	$AnimationPlayer.play("WalkIn")

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_select"):
		level_complete()
		
func level_complete():
	$AnimationPlayer.play("WalkOut")


func _on_Button_pressed():
	level_complete()

func set_signal(value):
	$MarginContainer2/HBoxContainer/VBoxContainer/Signal.set_signal(value)