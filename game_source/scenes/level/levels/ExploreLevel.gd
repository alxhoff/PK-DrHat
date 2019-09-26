extends Node

const LEVEL_NAME = "Explore"
const COLLECTION_THRESHOLD = 95

var target_becon = 0
var target_set = false

var item_count = 0
var speech_text = ""
var last_update_times = [0,0,0,0,0,0]

export (int) var update_period = 100

var signals = [] 

func _ready():
	$HBoxContainer/BtBars/BUZZER/AnimationPlayer.play("grow")
	$HBoxContainer/BtBars/LED/AnimationPlayer.play("Flash")
	$HBoxContainer/BtBars/SERVO/AnimationPlayer.play("swing")
	$SpeachBubble.set_flip_h(true)
	for time in last_update_times:
		time = OS.get_ticks_msec()
	$Player.position = Vector2(-200,37)
	$AnimationPlayer.play("WalkIn")
	
func speak():
	$SpeachBubble.say_text(speech_text, 3)

func init(ic, speech):
	speech_text = speech
	item_count = ic
	signals = [
$HBoxContainer/BtBars/VBoxContainer/SB1,
$HBoxContainer/BtBars/VBoxContainer/SB2,
$HBoxContainer/BtBars/VBoxContainer/SB3,
$HBoxContainer/BtBars/VBoxContainer/SB4,
$HBoxContainer/BtBars/VBoxContainer/SB5,
$HBoxContainer/BtBars/VBoxContainer/SB6
]

	#Set up level
	if ic == 1:
		set_signal_bars_visibility([0])
		set_signal_update_period(2000)
		set_signal_granularity(20)
	elif ic == 2:
		set_signal_bars_visibility([0,1])
		set_signal_update_period(500)
		set_signal_granularity(20)
	elif ic == 3:
		set_signal_bars_visibility([])
		$HBoxContainer/BtBars/LED.visible = true
		pass
	elif ic == 4:
		set_signal_bars_visibility([])
		$HBoxContainer/BtBars/BUZZER.visible = true
		pass
	elif ic == 5:
		set_signal_bars_visibility([])
		$HBoxContainer/BtBars/SERVO.visible = true
		pass
	elif ic == 6:
		set_signal_bars_visibility(range(6))
		set_signal_update_period(200)
		set_signal_granularity(5)
		pass
	
func check_level_completion():
	if target_set:
		if signals[target_becon].value > COLLECTION_THRESHOLD:
			level_complete()
	
func set_target_becond(dev_num):
	target_becon = dev_num
	target_set = true

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_select"):
		level_complete()
		
func level_complete():
	$AudioEffects.play()
	$SpeachBubble.say_text("Found it!!", 2)
	$Timer.start()
	$Player.jump()

func _on_Button_pressed():
	level_complete()

func set_signal_bars_visibility(bars):
	$HBoxContainer/BtBars/LED.visible = false
	$HBoxContainer/BtBars/BUZZER.visible = false
	$HBoxContainer/BtBars/SERVO.visible = false
	for bar in range(6):
		signals[bar].visible = false
	for bar in bars:
		signals[bar].visible = true

func set_signal(device, value):
	var cur_time = OS.get_ticks_msec()
	if (OS.get_ticks_msec() - last_update_times[device]) > update_period:
		signals[device].display_signal(value)
		last_update_times[device] = OS.get_ticks_msec()

func set_signal_granularity(step):
	for progBar in signals:
		progBar.set_granularity(step)
		
func set_signal_update_period(period):
	update_period = period

func _on_Timer_timeout():
	$AnimationPlayer.play("WalkOut")
