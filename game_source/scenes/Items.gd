extends Node

var item_count = 0

signal item_count_updated(count)

func _ready():
	pass # Replace with function body.

func _on_IntroLevel_key_given():
	item_count = 1
	emit_signal("item_count_updated", item_count)
