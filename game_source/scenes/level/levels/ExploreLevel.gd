extends Node

signal open_inventory

func _ready():
	$AnimationPlayer.play("WalkIn")
	pass # Replace with function body.


func _on_Inventory_pressed():
	emit_signal("open_inventory")
