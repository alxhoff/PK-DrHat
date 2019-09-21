extends Node



func _ready():
	$AnimationPlayer.play("WalkIn")
	

func _on_MenuButton_pressed():
	print("Menu buytton clicked")


func _on_Button_pressed():
	("Chest clicked")
