extends CanvasLayer

onready var sword = $HBox/LHB/NP/Sword
onready var boots = $HBox/LHB/NP1/Boots
onready var gloves = $HBox/LHB/NP2/Gloves
onready var helmet = $HBox/RHB/NP3/Helmet
onready var chest = $HBox/RHB/NP4/Chest
onready var phd = $HBox/RHB/NP5/Phd

func _ready():
	show(false, 0)
	all_enabled(false)
	pass
	
func all_enabled(value):
	sword.enable(value)
	boots.enable(value)
	gloves.enable(value)
	helmet.enable(value)
	chest.enable(value)
	phd.enable(value)
	
func all_visible(value):
	sword.visible(value)
	boots.visible(value)
	gloves.visible(value)
	helmet.visible(value)
	chest.visible(value)
	phd.visible(value)

	
func display_items(count):
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
		
func show(value, count):
	$HBox/MarginContainer/AnimatedPlayerSprite.visible = value
	$HBox/LHB/NP.visible = value
	$HBox/LHB/NP1.visible = value
	$HBox/LHB/NP2.visible = value
	$HBox/RHB/NP3.visible = value
	$HBox/RHB/NP4.visible = value
	$HBox/RHB/NP5.visible = value
	all_visible(value)
	$Background.visible = value
	display_items(count)

func _on_Timer_timeout():
	show(false, 0)

func _on_Items_show_inventory_items(count):
	show(true, count)
