extends Node

signal show_inventory


func _ready():
	$AnimationPlayer.play("WalkIn")

func _physics_process(delta):
	if Input.is_action_pressed("ui_select"):
		$Player.increment_items()