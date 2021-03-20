extends Node2D

export var enemy_demon_l : PackedScene
export var shoot_scene : PackedScene
onready var player : KinematicBody2D = $Player
onready var spawn_timer : Timer = $SpawnTimer

func _ready():
	player.connect("shoot_projectile", self, "on_player_shoot_projectile")
	spawn_timer.connect("timeout", self, "spawn_enemy")

func on_player_shoot_projectile(color):
	var direction : Vector2 = (get_global_mouse_position() - player.global_position).normalized()
	var pos = player.global_position + direction * 24
	var shoot = shoot_scene.instance()
	shoot.setup(pos, direction, color)
	add_child(shoot)

func spawn_enemy():
	pass
