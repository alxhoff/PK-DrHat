extends Node

signal show_inventory
signal level_completed

func _ready():
	$AnimatedSprite.play("Idle")
	pass

func run():
	$AnimatedSprite.play("RunBadge")
	
func idle():
	$AnimatedSprite.play("Idle")

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("level_completed")

func show_inventory():
	emit_signal("show_inventory")