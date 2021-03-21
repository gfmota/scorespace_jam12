extends Node2D

onready var anim_title : AnimationPlayer = $AnimationPlayer
onready var play_btn : Button = $Play
onready var leaderboard_btn : Button = $Leaderboard
onready var how2play_btn : Button = $HowToPlay
onready var credits_btn : Button = $Credits

func _ready():
	play_btn.connect("pressed", self, "on_play_pressed")
	leaderboard_btn.connect("pressed", self, "on_leaderboard_pressed")
	how2play_btn.connect("pressed", self, "on_how2play_pressed")
	credits_btn.connect("pressed", self, "on_credits_pressed")
	anim_title.play("title")

func on_play_pressed():
	pass

func on_leaderboard_pressed():
	pass

func on_how2play_pressed():
	pass

func on_credits_pressed():
	pass
