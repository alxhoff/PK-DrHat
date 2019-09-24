extends Node

const LEVEL_NAME = "Explore"

onready var signals = [
$HBoxContainer/BtBars/VBoxContainer/SignalBar1,
$HBoxContainer/BtBars/VBoxContainer/SignalBar2,
$HBoxContainer/BtBars/VBoxContainer/SignalBar3,
$HBoxContainer/BtBars/VBoxContainer/SignalBar4,
$HBoxContainer/BtBars/VBoxContainer/SignalBar5,
$HBoxContainer/BtBars/VBoxContainer/SignalBar6
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
	signals[device].display_signal(value)