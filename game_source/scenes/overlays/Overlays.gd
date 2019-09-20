extends Node

onready var keyRGB = $Items/MarginUI/Border/HBoxItems/MarginKey/KeyRGB
onready var key = $Items/MarginUI/Border/HBoxItems/MarginKey/Key
onready var swordRGB = $Items/MarginUI/Border/HBoxItems/MarginSword/SwordRGB
onready var sword = $Items/MarginUI/Border/HBoxItems/MarginSword/Sword
onready var bootsRGB = $Items/MarginUI/Border/HBoxItems/MarginBoots/BootsRGB
onready var boots = $Items/MarginUI/Border/HBoxItems/MarginBoots/Boots
onready var glovesRGB = $Items/MarginUI/Border/HBoxItems/MarginGloves/GlovesRGB
onready var gloves = $Items/MarginUI/Border/HBoxItems/MarginGloves/Gloves
onready var helmetRGB = $Items/MarginUI/Border/HBoxItems/MarginHelmet/HelmetRGB
onready var helmet = $Items/MarginUI/Border/HBoxItems/MarginHelmet/Helmet
onready var chestRGB = $Items/MarginUI/Border/HBoxItems/MarginChest/ChestRGB
onready var chest = $Items/MarginUI/Border/HBoxItems/MarginChest/Chest
onready var phdRGB = $Items/MarginUI/Border/HBoxItems/MarginPhD/PhDRGB
onready var phd = $Items/MarginUI/Border/HBoxItems/MarginPhD/PhD

func _ready():
	display_items(0)
	all_visible(false)
	
func all_visible(value):
	keyRGB.visible = value
	key.visible = value
	swordRGB.visible = value
	sword.visible = value
	bootsRGB.visible = value
	boots.visible = value
	glovesRGB.visible = value
	gloves.visible = value
	helmetRGB.visible = value
	helmet.visible = value
	chestRGB.visible = value
	chest.visible = value
	phdRGB.visible = value
	phd.visible = value
	
	
func display_items(count):
	if count >= 7:
		phdRGB.visible = true
		phd.visible = false
	if count >= 6:
		chestRGB.visible = true
		chest.visible = false
	if count >= 5:
		helmetRGB.visible = true
		helmet.visible = false
	if count >= 4:
		glovesRGB.visible = true
		gloves.visible = false
	if count >= 3:
		bootsRGB.visible = true
		boots.visible = false
	if count >= 2:
		swordRGB.visible = true
		sword.visible = false
	if count >= 1:
		keyRGB.visible = true
		key.visible = false


func _on_Items_item_count_changed(count):
	display_items(count)


func _on_Items_item_count_updated(count):
	display_items(count)
