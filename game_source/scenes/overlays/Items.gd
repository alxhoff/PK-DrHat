extends Node

var item_count = 6

signal inventory_item_count_updated(count)
signal UI_item_count_updated(count)

func _ready():
	pass # Replace with function body.

func show_inventory():
	emit_signal("inventory_item_count_updated", item_count)

func show_item_UI():
	emit_signal("UI_item_count_updated", item_count)

func _on_ItemCount_updated(count):
	item_count = count
	emit_signal("UI_item_count_updated", item_count)

func _on_ItemCount_incremented():
	item_count += 1
	emit_signal("UI_item_count_updated", item_count)
