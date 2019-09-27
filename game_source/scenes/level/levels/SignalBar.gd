extends CenterContainer

export (int) var dev_num = 0
var cur_value = 0

func _ready():
	$Label.text = str(dev_num)
	
func get_value():
	return cur_value
	
func display_signal(value):
	cur_value = value
	$TextureProgress.value = value

func set_granularity(step):
	$TextureProgress.step = step
	
func enable(value):
	$TextureProgress.visible  = value
	$Label.visible = value
