extends Node

var item_count = 0

signal item_count_changed(count)
signal show_inventory_items(count)

func _ready():
	pass

func set_item_count(count):
	emit_signal("item_count_changed", item_count)

func _on_Player_show_inventory():
	emit_signal("show_inventory_items", item_count)
