extends Node

signal show_inventory

func _ready():
	$Player.position = Vector2(-200,37)
	$AnimationPlayer.play("WalkIn")

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_select"):
		level_complete()
		
func level_complete():
	$AnimationPlayer.play("WalkOut")