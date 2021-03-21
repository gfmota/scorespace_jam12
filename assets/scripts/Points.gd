extends Node2D

var text : String
onready var label : Label = $Label
onready var tween : Tween = $Tween

func _ready():
	tween.connect("tween_all_completed", self, "on_tween_all_completed")
	label.text = text
	tween.interpolate_property(self, "position:y", global_position.y, global_position.y - 32, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()

func setup(value, pos):
	global_position = pos
	text = str(value)

func on_tween_all_completed():
	call_deferred("free")
