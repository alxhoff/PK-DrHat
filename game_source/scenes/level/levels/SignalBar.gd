extends CenterContainer

export (int) var dev_num = 0

func _ready():
	$Label.text = str(dev_num)
	
func display_signal(value):
	$TextureProgress.value = value

func set_granularity(step):
	$TextureProgress.step = step
