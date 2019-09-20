extends Node

onready var key = $MarginUI/Border/HBoxItems/Key
onready var sword = $MarginUI/Border/HBoxItems/Sword
onready var boots = $MarginUI/Border/HBoxItems/Boots
onready var gloves = $MarginUI/Border/HBoxItems/Gloves
onready var helmet = $MarginUI/Border/HBoxItems/Helmet
onready var chest = $MarginUI/Border/HBoxItems/Chest
onready var phd = $MarginUI/Border/HBoxItems/PhD
onready var bg = $MarginUI/NinePatchRect

func _ready():
	display_items(0)
	all_visible(false)
	
func all_enabled(value):
	key.enable(value)
	sword.enable(value)
	boots.enable(value)
	gloves.enable(value)
	helmet.enable(value)
	chest.enable(value)
	phd.enable(value)
	
func all_visible(value):
	key.visible(value)
	sword.visible(value)
	boots.visible(value)
	gloves.visible(value)
	helmet.visible(value)
	chest.visible(value)
	phd.visible(value)
	bg.visible = value
	
func display_items(count):
	all_visible(true)
	all_enabled(false)
	
	if count >= 7:
		phd.enable(true)
	if count >= 6:
		chest.enable(true)
	if count >= 5:
		helmet.enable(true)
	if count >= 4:
		gloves.enable(true)
	if count >= 3:
		boots.enable(true)
	if count >= 2:
		sword.enable(true)
	if count >= 1:
		key.enable(true)


func _on_Items_item_count_changed(count):
	display_items(count)


func _on_Items_item_count_updated(count):
	display_items(count)
