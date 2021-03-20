extends Node2D

const SPEED : int = 350
var direction : Vector2
var colors : Array = [Color8(0, 190, 90), Color8(0, 190, 140), Color8(190, 255, 0), Color8(0, 220, 220), Color8(255, 120, 0), Color8(255, 255, 255), Color8(0, 150, 255), Color8(150, 60, 255), Color8(255, 60, 190), Color8(255, 30, 0)]

func _process(delta):
	position += direction * SPEED * delta

func setup(pos, dir, color):
	global_position = pos
	direction = dir
	rotation_degrees = rad2deg(dir.angle())
	match color:
		Vector3(3, 0, 0):
			modulate = colors[0]
		Vector3(2, 1, 0):
			modulate = colors[1]
		Vector3(2, 0, 1):
			modulate = colors[2]
		Vector3(1, 2, 0):
			modulate = colors[3]
		Vector3(1, 0, 2):
			modulate = colors[4]
		Vector3(1, 1, 1):
			modulate = colors[5]
		Vector3(0, 3, 0):
			modulate = colors[6]
		Vector3(0, 2, 1):
			modulate = colors[7]
		Vector3(0, 1, 2):
			modulate = colors[8]
		Vector3(0, 0, 3):
			modulate = colors[9]
