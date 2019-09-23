extends Node

signal show_inventory
signal level_completed
signal increment_item_count

func _ready():
	connect("show_inventory", get_tree().get_root().get_node("World").find_node("Items"), 
	"show_inventory")
	connect("increment_item_count", get_tree().get_root().get_node("World").find_node("Items"), 
	"_on_ItemCount_incremented")
	$AnimatedSprite.play("Idle")


func run():
	$AnimatedSprite.play("RunBadge")
	
func idle():
	$AnimatedSprite.play("Idle")

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("level_completed")

func show_inventory():
	emit_signal("show_inventory")
	
func increment_items():
	emit_signal("increment_item_count")
