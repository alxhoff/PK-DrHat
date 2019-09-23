extends Node

signal item_count_changed(count)

func _ready():
	pass

func set_item_count(count):
	emit_signal("item_count_changed", count)


