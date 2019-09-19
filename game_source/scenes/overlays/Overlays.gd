extends Node

func _ready():
	display_items(0)
	pass
	
func display_items(count):
	var key = $Inventory/MarginUI/HBoxItems/MarginKey/Key
	var sword = $Inventory/MarginUI/HBoxItems/MarginSword/Sword
	var boots = $Inventory/MarginUI/HBoxItems/MarginBoots/Boots
	var gloves = $Inventory/MarginUI/HBoxItems/MarginGloves/Gloves
	var helmet = $Inventory/MarginUI/HBoxItems/MarginHelmet/Helmet
	var chest = $Inventory/MarginUI/HBoxItems/MarginChest/Chest
	var phd = $Inventory/MarginUI/HBoxItems/MarginPhD/PhD
	
	key.visible = false
	sword.visible = false
	boots.visible = false
	gloves.visible = false
	helmet.visible = false
	chest.visible = false
	phd.visible = false
	
	if count >= 7:
		phd.visible = true
	if count >= 6:
		chest.visible = true
	if count >= 5:
		helmet.visible = true
	if count >= 4:
		gloves.visible = true
	if count >= 3:
		boots.visible = true
	if count >= 2:
		sword.visible = true
	if count >= 1:
		key.visible = true


func _on_Items_item_count_changed(count):
	display_items(count)
