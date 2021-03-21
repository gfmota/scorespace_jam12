extends Node2D

onready var btn : Button = $Button
onready var input : LineEdit = $LineEdit
onready var score_text : Label = $Score

func _ready():
	btn.connect("pressed", self, "on_btn_pressed")

func on_btn_pressed():
	if input.text.length() > 0:
		emit_signal("s")
