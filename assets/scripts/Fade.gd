extends Node2D

signal end_fade_in
signal end_fade_out
var is_in : bool
onready var color_rect : ColorRect = $ColorRect
onready var tween : Tween = $Tween

func _ready():
	tween.connect("tween_all_completed", self, "on_tween_all_completed")

func fade_in():
	visible = true
	tween.interpolate_property(color_rect, "modulate:a", 1, 0, 0.5)
	tween.start()
	is_in = true

func fade_out():
	visible = true
	tween.interpolate_property(color_rect, "modulate:a", 0, 1, 0.5)
	tween.start()
	is_in = false

func on_tween_all_completed():
	emit_signal("end_fade_in" if is_in else "end_fade_out")
	visible = false
