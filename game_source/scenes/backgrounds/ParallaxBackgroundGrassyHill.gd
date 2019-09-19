extends ParallaxBackground

func _physics_process(delta):
	$AnimationPlayer.play("moveBackground")
	pass
