extends Node2D

export var shoot_scene : PackedScene
onready var player : KinematicBody2D = $Player

func _ready():
	player.connect("shoot_projectile", self, "on_player_shoot_projectile")

func on_player_shoot_projectile(colors):
	var direction : Vector2 = (get_global_mouse_position() - player.global_position).normalized()
	var pos = player.global_position + direction * 24
	var blue_count : float = 0
	var green_count : float = 0
	var red_count : float = 0
	for color in colors:
		print(color)
		match color:
			1:
				green_count += 1
			2:
				blue_count += 1
			3:
				red_count += 1
	var shoot = shoot_scene.instance()
	shoot.setup(pos, direction, Vector3(green_count, blue_count, red_count))
	add_child(shoot)
