extends Node

const LEVEL_NAME = "Explore"
const COLLECTION_THRESHOLD = 95

var target_becon = 0
var target_set = false

var item_count = 0

var last_update_times = [0,0,0,0,0,0]

export (int) var update_period = 100

onready var signals = [
$HBoxContainer/BtBars/VBoxContainer/SignalBar1,
$HBoxContainer/BtBars/VBoxContainer/SignalBar2,
$HBoxContainer/BtBars/VBoxContainer/SignalBar3,
$HBoxContainer/BtBars/VBoxContainer/SignalBar4,
$HBoxContainer/BtBars/VBoxContainer/SignalBar5,
$HBoxContainer/BtBars/VBoxContainer/SignalBar6
]

func _ready():
	$SpeachBubble.set_flip_h(true)
	hide_all_bars(false)
	for time in last_update_times:
		time = OS.get_ticks_msec()
	$Player.position = Vector2(-200,37)
	$AnimationPlayer.play("WalkIn")
	
func init(ic):
	item_count = ic
	
	#Set up level
	if ic == 1:
		set_signal_bars_visibility([0], true)
		set_signal_update_period(2000)
		set_signal_granularity(20)
	elif ic == 2:
		set_signal_bars_visibility([0,1], true)
		set_signal_update_period(500)
		set_signal_granularity(20)
	elif ic == 3:
		set_signal_bars_visibility(range(6), false)
		$SpeachBubble.say_text("Looks like a strange light is signaling", 3)
		$HBoxContainer/BtBars/LED.visible = true
		pass
	elif ic == 4:
		set_signal_bars_visibility(range(6), false)
		$SpeachBubble.say_text("What is that sound?!?!", 3)
		$HBoxContainer/BtBars/BUZZER.visible = true
		pass
	elif ic == 5:
		set_signal_bars_visibility(range(6), false)
		$HBoxContainer/BtBars/SERVO.visible = true
		$SpeachBubble.say_text("Rise of the machines!", 3)
		pass
	elif ic == 6:
		set_signal_bars_visibility(range(6), true)
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
	$SpeachBubble.say_text("Found it!!", 2)
	$Timer.start()
	$Player.jump()

func _on_Button_pressed():
	level_complete()
	
func hide_all_bars(value):
	var bars = range(6)
	if value:
		set_signal_bars_visibility(bars, false)
	else:
		set_signal_bars_visibility(bars, true)

func set_signal_bars_visibility(bars, value):
	$HBoxContainer/BtBars/LED.visible = false
	$HBoxContainer/BtBars/BUZZER.visible = false
	$HBoxContainer/BtBars/SERVO.visible = false
	for bar in bars:
		signals[bar].visible = value

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
