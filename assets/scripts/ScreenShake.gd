extends Node

onready var rng = RandomNumberGenerator.new()
var amplitude : float = 8
onready var camera : Node2D = get_parent()
onready var duration : Timer = $DurationTimer
onready var frequency : Timer = $FrequencyTimer
onready var tween : Tween = $Tween

func _ready():
	duration.connect("timeout", self, "on_duration_timeout")
	frequency.connect("timeout", self, "on_frequency_timeout")
	rng.randomize()

func start():
	frequency.start()
	duration.start()
	new_shake()

func new_shake():
	var rand = Vector2(rng.randf_range(-amplitude, amplitude), rng.randf_range(-amplitude, amplitude))
	tween.interpolate_property(camera, "position", camera.position, rand, frequency.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func on_frequency_timeout():
	new_shake()

func on_duration_timeout():
	frequency.stop()
	reset()

func reset():
	tween.interpolate_property(camera, "position", camera.position, Vector2.ZERO, frequency.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

