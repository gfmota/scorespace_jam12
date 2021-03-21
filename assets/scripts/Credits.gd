extends Node2D

onready var back_btn : Button = $Button
onready var fade : Node2D = $Fade

func _ready():
	back_btn.connect("pressed", self, "on_back_btn_pressed")
	fade.connect("end_fade_out", self, "on_fade_out_ended")
	fade.fade_in()

func on_back_btn_pressed():
	fade.fade_out()
	ButtonSFX.play()

func on_fade_out_ended():
	get_tree().change_scene("res://assets/scenes/Menu.tscn")
