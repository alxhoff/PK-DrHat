extends Node

signal increment_item_count

var intro_strings = []

var item_name = ""
var item_sprite = null
var level_ready = false
var string_index = 0
var level_complete = false

func _ready():
	connect("increment_item_count", get_tree().get_root().get_node("World").find_node("Items"), 
	"_on_ItemCount_incremented")
	$Guide/AnimationPlayer.play("EnterScreen")

	
func init(item, item_sprite_path):
	item_name = item
	item_sprite = load(item_sprite_path)
	intro_strings = [
"",
"Hello again Philipp...", 
"It looks like you have found...",
"The AMAZING %s" % item_name,
"",
"Well done, your next riddle is", 
"INSERT RIDDLE",
"Now go forth and find the next becon", 
""
]
	level_ready = true
	
func _physics_process(delta):
	if level_ready:
		if $Guide.ready == true && level_complete == false:
			if $Guide.busy() == false:
				if string_index < intro_strings.size():
					if string_index == 0:
						$Guide.delay(4)
						
					$Guide.say_string(intro_strings[string_index], 1)
					string_index += 1
					
					if string_index == 5:
						$Guide.show_item(item_sprite)
						$Guide.delay(2)
					if string_index == 6:
						$Guide.hide_item()
	
				else:
					$Guide.stop_talking()
					$Guide.hide_item()
					level_finished()
				
func level_finished():
	level_complete = true
	$Guide/AnimationPlayer.play("LeaveScreen")
