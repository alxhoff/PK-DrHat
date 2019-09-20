extends MarginContainer

export (Texture) var sprite_path = null

var ready = false

func visible(value):
	$BW.visible = value
	$RGB.visible = value

func enable(value):
	if ready:
		if value:
			$RGB.visible = true
			$BW.visible = false
		else:
			$RGB.visible = false
			$BW.visible = true

func _ready():
	if sprite_path:
		$BW.set_texture(load(str(sprite_path)))
		$RGB.set_texture(load(str(sprite_path)))
		ready = true
