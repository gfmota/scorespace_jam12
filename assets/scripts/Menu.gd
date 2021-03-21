extends Node2D

var next_scene : String
onready var anim_title : AnimationPlayer = $AnimationPlayer
onready var play_btn : Button = $Play
onready var leaderboard_btn : Button = $Leaderboard
onready var how2play_btn : Button = $HowToPlay
onready var credits_btn : Button = $Credits
onready var fade : Node2D = $Fade

func _ready():
	play_btn.connect("pressed", self, "on_play_pressed")
	leaderboard_btn.connect("pressed", self, "on_leaderboard_pressed")
	how2play_btn.connect("pressed", self, "on_how2play_pressed")
	credits_btn.connect("pressed", self, "on_credits_pressed")
	fade.connect("end_fade_out", self, "on_fade_out_end")
	anim_title.play("title")
	fade.fade_in()
	if not MenuMusic.playing:
		MenuMusic.play_music()

func on_play_pressed():
	next_scene = "res://assets/scenes/Arena.tscn"
	fade.fade_out()
	MenuMusic.stop_music()
	ButtonSFX.play()

func on_leaderboard_pressed():
	next_scene = "res://assets/scenes/Leaderboard.tscn"
	fade.fade_out()
	ButtonSFX.play()

func on_how2play_pressed():
	next_scene = "res://assets/scenes/HowToPlay.tscn"
	fade.fade_out()
	ButtonSFX.play()

func on_credits_pressed():
	next_scene = "res://assets/scenes/Credits.tscn"
	fade.fade_out()
	ButtonSFX.play()

func on_fade_out_end():
	get_tree().change_scene(next_scene)
