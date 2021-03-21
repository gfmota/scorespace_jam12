extends Node2D

var player_name : String
var player_score : int
onready var rank : Label = $Text

func _ready():
	var player_data = {
		"name" : player_name if player_name else "",
		"points" : player_score if player_score else 0,
	}
	var data
	var file = File.new()
	if file.file_exists("user://save.dat"):
		file.open("user://save.dat", File.READ)
		data = file.get_var()
		file.close()
		for ind in range(0, 5):
			if player_data["points"] >= data["points" + str(5 - ind)]:
				if ind > 0:
					data["name" + str(6 - ind)] = data["name" + str(5 - ind)]
					data["points" + str(6 - ind)] = data["points" + str(5 - ind)]
				data["name" + str(5 - ind)] = player_data["name"]
				data["points" + str(5 - ind)] = player_data["points"]
		
		file.open("user://save.dat", File.WRITE)
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
		file.open("user://save.dat", File.WRITE)
		file.store_var(data)
	file.close()
	rank.text = "1. " + data["name1"] + " - " + str(data["points1"]).pad_zeros(10) + "\n2. " + data["name2"] + " - " + str(data["points2"]).pad_zeros(10) + "\n3. " + data["name3"] + " - " + str(data["points3"]).pad_zeros(10) + "\n4. " + data["name1"] + " - " + str(data["points1"]).pad_zeros(10) + "\n5. " + data["name2"] + " - " + str(data["points2"]).pad_zeros(10)

func setup(nam, score):
	player_name = nam
	player_score = score
