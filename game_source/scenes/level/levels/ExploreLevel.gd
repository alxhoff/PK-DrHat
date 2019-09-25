extends Node

const LEVEL_NAME = "Explore"

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
	hide_all_bars(true)
	for time in last_update_times:
		time = OS.get_ticks_msec()
	$Player.position = Vector2(-200,37)
	$AnimationPlayer.play("WalkIn")
	set_signal_granularity(1)
	set_signal_update_period(2000)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_select"):
		level_complete()
		
func level_complete():
	$AnimationPlayer.play("WalkOut")

func _on_Button_pressed():
	level_complete()
	
func hide_all_bars(value):
	var bars = range(6)
	if value:
		set_signal_bars_visibility(bars, false)
	else:
		set_signal_bars_visibility(bars, true)

func set_signal_bars_visibility(bars, value):
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