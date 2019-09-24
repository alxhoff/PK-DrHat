extends Node

const LEVEL_NAME = "Explore"

onready var signals = [
$MarginContainer2/HBoxContainer/VBoxContainer/Signal1,
$MarginContainer2/HBoxContainer/VBoxContainer/Signal2,
$MarginContainer2/HBoxContainer/VBoxContainer/Signal3,
$MarginContainer2/HBoxContainer/VBoxContainer/Signal4,
$MarginContainer2/HBoxContainer/VBoxContainer/Signal5,
$MarginContainer2/HBoxContainer/VBoxContainer/Signal6,
]

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

func set_signal(device, value):
	var dev = signals[device]
	signals[device].set_signal(value)