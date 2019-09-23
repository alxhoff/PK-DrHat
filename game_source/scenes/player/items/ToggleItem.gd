extends MarginContainer

export (Texture) var sprite_path = null

var ready = false

func visible(value):
	$BW.visible = value
	$RGB.visible = value

func enable(value):
	if ready:
		if value:
#			var RGB_mod = $RGB.get_modulate()
#			RGB_mod.a = 0
#			$RGB.set_modulate(RGB_mod)
			var bw = $BW
			var rgb = $RGB
			print("Turned solid")
			$BW.visible = false
			$RGB.visible = true
#			$AnimationPlayer.play("turnSolid")
		else:
			var BW_mod = $BW.get_modulate()
			BW_mod.a8 = 150
			$BW.set_modulate(BW_mod)
			$BW.visible = true
			$RGB.visible = false
			print("Show BW")
			


func _ready():
	if sprite_path:
		$BW.set_texture(load(str(sprite_path.get_load_path())))
		$RGB.set_texture(load(str(sprite_path.get_load_path())))
		$BW.visible = false
		$RGB.visible = false
		ready = true
