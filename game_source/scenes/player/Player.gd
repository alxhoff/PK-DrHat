extends Node

func _ready():
	$AnimatedSprite.play("Idle")
	pass

func run():
	$AnimatedSprite.play("RunBadge")