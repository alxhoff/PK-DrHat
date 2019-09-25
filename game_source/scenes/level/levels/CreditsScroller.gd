extends Node2D

const CHAR_SPEECH_TIME = 0.06

export (String) var credits_file_path

onready var credits_static = $Label2

var credits_file = File.new()

var compiled_lines = "\n\n"
var displaying_line = 0

func _ready():
	$CharTimer.set_wait_time(CHAR_SPEECH_TIME)
	
	if credits_file.file_exists(credits_file_path):
		credits_file.open(credits_file_path, credits_file.READ)

		while credits_file.eof_reached() == false:
			var line = credits_file.get_line()
			compiled_lines += line + "\n"

		credits_static.text = compiled_lines
	else:
		printt("Unable to open credits file")
	

func _on_CharTimer_timeout():
	position = Vector2(0, global_position.y - 1)
