extends TextureButton

func _ready():
	connect("open_inventory", get_tree().get_root().find_node("Inventory"), "_on_Items_show_inventory_items")
	pass # Replace with function body.

signal open_inventory

func _on_Inventory_pressed():
	print("Inventory pressed")
	emit_signal("open_inventory")

