extends Node2D

onready var black_filter : ColorRect = $ColorRect
onready var game_over : bool = false
onready var game_over_node : Node2D = $GameOver
onready var tween : Tween = $Tween

func _input(event):
	if event.is_action_pressed("pause") and not game_over:
		get_tree().paused = !get_tree().paused
		black_filter.visible = !black_filter.visible

func game_over(score):
	game_over = true
	black_filter.visible = true
	
	Global.player_score = score
	game_over_node.get_node("Score").text = str(score).pad_zeros(3)
	game_over_node.get_node("Button").connect("pressed", self, "on_gameover_btn_pressed")
	
	tween.interpolate_property(game_over_node, "position:y", -600, 0, 0.5, Tween.EASE_OUT)
	tween.start()

func on_gameover_btn_pressed():
	if game_over_node.get_node("LineEdit").text.length() > 0:
		Global.player_name = game_over_node.get_node("LineEdit").text
		get_parent().get_node("Fade").fade_out()
		InGameMusic.stop_music()
		ButtonSFX.play()

func on_end_fade_out():
	get_tree().change_scene("res://assets/scenes/Leaderboard.tscn")
