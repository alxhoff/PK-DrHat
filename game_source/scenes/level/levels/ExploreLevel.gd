extends Node

const LEVEL_NAME = "Explore"

onready var signals = [
$BtBars/VBoxContainer/SignalBar
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
	signals[0].display_signal(value)