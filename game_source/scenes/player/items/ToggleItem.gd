extends MarginContainer

export (Texture) var sprite_path = null

var ready = false

func visible(value):
	$BW.visible = value
	$RGB.visible = value

func enable(value):
	if ready:
		if value:
			$AnimationPlayer.play("turnSolid")
		else:
			$RGB.visible = false
			$BW.visible = true

func _ready():
	if sprite_path:
		$BW.set_texture(load(str(sprite_path.get_load_path())))
		$RGB.set_texture(load(str(sprite_path.get_load_path())))
		ready = true
		$BW.visible = true
		$RGB.visible = true
