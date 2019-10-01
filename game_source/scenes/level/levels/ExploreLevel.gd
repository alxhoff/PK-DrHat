extends Node

const LEVEL_NAME = "Explore"
const COLLECTION_THRESHOLD = 65

export (int) var update_period = 100

var target_becon = 0
var target_set = false
var level_completed = false

var item_count = 0
var speech_text = ""
var signals = [] 
var last_update_times = [0,0,0,0,0,0]
var cur_letters = 0
var prev_led = 0
var prev_buzzer = 0
var prev_servo = 0

signal update_led(frequency, period)
signal update_buzzer(frequency, period)
signal update_servo(value)

func _ready():
	
	connect("update_led", get_tree().get_root().get_node("World").find_node("UDPClient"), 
	"send_led")
	connect("update_buzzer", get_tree().get_root().get_node("World").find_node("UDPClient"), 
	"send_beep")
	connect("update_servo", get_tree().get_root().get_node("World").find_node("UDPClient"), 
	"send_servo")
	
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
	emit_signal("update_led", 0, 0)
	emit_signal("update_buzzer", 0, 0)
	emit_signal("update_servo", 0)
	signals = [
$HBoxContainer/BtBars/VBoxContainer/SB1,
$HBoxContainer/BtBars/VBoxContainer/SB2,
$HBoxContainer/BtBars/VBoxContainer/SB3,
$HBoxContainer/BtBars/VBoxContainer/SB4,
$HBoxContainer/BtBars/VBoxContainer/SB5,
$HBoxContainer/BtBars/VBoxContainer/SB6
]
	level_completed = false
	if ic == 0:
		set_target_becon(0)
	else:
		set_target_becon(ic-1)
	speech_text = speech
	item_count = ic
	
	#Set up level
	if ic == 1 or ic == 0:
		set_signal_bars_visibility([0])
		set_signal_update_period(100)
		set_signal_granularity(10)
	elif ic == 2:
		set_signal_bars_visibility([0,1])
		set_signal_update_period(500)
		set_signal_granularity(20)
	elif ic == 3:
		set_signal_bars_visibility([])
		$HBoxContainer/BtBars/LED.visible = true
		pass
	elif ic == 4:
		set_signal_bars_visibility(range(4))
		set_signal_update_period(200)
		set_signal_granularity(5)
		pass
	elif ic == 5:
		set_signal_bars_visibility([])
		$HBoxContainer/BtBars/SERVO.visible = true
		pass
	elif ic == 6:		
		set_signal_bars_visibility([])
		$HBoxContainer/BtBars/BUZZER.visible = true
		pass
	
func check_level_completion():
	if target_set:
		if (item_count - 1) < cur_letters and level_completed == false:
			level_complete()
	
func set_target_becon(dev_num):
	target_becon = dev_num
	target_set = true

func _physics_process(delta):

	if item_count == 3:
		var cur_val = signals[item_count - 1].get_value()
		if prev_led != cur_val:
			var led_vals = get_led_values(cur_val)
			prev_led = cur_val
			emit_signal("update_led", led_vals[0], led_vals[1])

	elif item_count == 6: #BUZZER
		var cur_val = signals[item_count - 1].get_value()
		if prev_buzzer != cur_val:
			var buzzer_vals = get_buzzer_values(cur_val)
			prev_buzzer = cur_val
			emit_signal("update_buzzer", buzzer_vals[0], buzzer_vals[1])

	elif item_count == 5: #SERVO
		var cur_val = signals[item_count - 1].get_value()
		if prev_servo != cur_val:
			var servo_vals = get_servo_values(cur_val)
			prev_servo = cur_val
			emit_signal("update_servo", servo_vals)

	check_level_completion()
	
#0% signal = 1000 second DS 
#100% signal = 200ms DS 
func get_led_values(value):
	var duty_cycle = value
	var interval = -19 * value + 2000

	return [duty_cycle, interval]

func get_buzzer_values(value):
	return get_led_values(value)
	
func get_servo_values(value):
	return value

func level_complete():
	level_completed = true
	emit_signal("update_led", 0, 0)
	emit_signal("update_buzzer", 0, 0)
	emit_signal("update_servo", 0)
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
	
func set_letters(count):
	cur_letters = count

func _on_Timer_timeout():
	$AnimationPlayer.play("WalkOut")
