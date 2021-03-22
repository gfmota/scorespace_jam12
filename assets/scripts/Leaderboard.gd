extends Node2D

onready var fade : Node = $Fade
onready var menu_btn : Button = $Button
onready var rank : Label = $Text

func _ready():
	fade.connect("end_fade_out", self, "on_end_fade_out")
	menu_btn.connect("pressed", self, "on_menu_btn_pressed")
	fade.fade_in()
	if not MenuMusic.playing:
		MenuMusic.play_music()
	
	var player_data = {
		"name" : Global.player_name if Global.player_name else "xxx",
		"points" : Global.player_score if Global.player_score else 0,
	}
	var data
	var file = File.new()
	if file.file_exists("user://rank.dat"):
		file.open("user://rank.dat", File.READ)
		data = file.get_var()
		file.close()
		for ind in range(0, 5):
			if player_data["points"] >= data["points" + str(5 - ind)]:
				if ind > 0:
					data["name" + str(6 - ind)] = data["name" + str(5 - ind)]
					data["points" + str(6 - ind)] = data["points" + str(5 - ind)]
				data["name" + str(5 - ind)] = player_data["name"]
				data["points" + str(5 - ind)] = player_data["points"]
		
		file.open("user://rank.dat", File.WRITE)
		file.store_var(data)
		file.store_var(data)
	else:
		data = {
			"name1" : player_data["name"],
			"points1" : player_data["points"],
			"name2" : "xxx",
			"points2" : 0,
			"name3" : "xxx",
			"points3" : 0,
			"name4" : "xxx",
			"points4" : 0,
			"name5" : "xxx",
			"points5" : 0,
		}
		file.open("user://rank.dat", File.WRITE)
		file.store_var(data)
	file.close()
	rank.text = "1. " + data["name1"].to_upper() + " - " + str(data["points1"]).pad_zeros(10) + "\n2. " + data["name2"].to_upper() + " - " + str(data["points2"]).pad_zeros(10) + "\n3. " + data["name3"].to_upper() + " - " + str(data["points3"]).pad_zeros(10) + "\n4. " + data["name4"].to_upper() + " - " + str(data["points4"]).pad_zeros(10) + "\n5. " + data["name5"].to_upper() + " - " + str(data["points5"]).pad_zeros(10)
	Global.player_name = "XXX"
	Global.player_score = 0

func on_menu_btn_pressed():
	fade.fade_out()
	ButtonSFX.play()

func on_end_fade_out():
	get_tree().change_scene("res://assets/scenes/Menu.tscn")
