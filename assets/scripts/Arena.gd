extends Node2D

export var enemy_demon_s : PackedScene
export var enemy_demon_m : PackedScene
export var enemy_demon_l : PackedScene
export var points_scene : PackedScene
export var shoot_scene : PackedScene
var rng = RandomNumberGenerator.new()
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var health : int = 6
onready var hearts : Sprite = $Hearts
onready var player : KinematicBody2D = $Player
onready var screen_shake : Node = $ScreenShake
onready var score : int = 0
onready var score_label : Label = $Score/Label
onready var spawn_locations : Node2D = $SpawnLocations
onready var spawn_timer : Timer = $SpawnTimer

func _ready():
	player.connect("shoot_projectile", self, "on_player_shoot_projectile")
	player.connect("damaged", self, "on_player_damaged")
	spawn_timer.connect("timeout", self, "spawn_enemy")
	
	animation_player.play("hud")

func on_player_shoot_projectile(color):
	var direction : Vector2 = (get_global_mouse_position() - player.global_position).normalized()
	var pos = player.global_position + direction * 24
	var shoot = shoot_scene.instance()
	shoot.setup(pos, direction, color)
	add_child(shoot)

func on_player_damaged():
	health -= 1
	hearts.frame += 1
	screen_shake.start()
	if health == 0:
		# Game over
		pass

func spawn_enemy():
	rng.randomize()
	var location : int = rng.randi_range(0, 3)
	var ini_pos : Vector2
	match location:
		0:
			ini_pos = spawn_locations.get_node("TopLeft").position
		1:
			ini_pos = spawn_locations.get_node("TopRight").position
		2:
			ini_pos = spawn_locations.get_node("BottomLeft").position
		3:
			ini_pos = spawn_locations.get_node("BottomRight").position
	var angle = rng.randf_range(0, 2 * PI)
	var end_pos : Vector2 = ini_pos + 64 * Vector2(cos(angle), sin(angle))
	var enemy
	match rng.randi_range(0, 1):
		0:
			enemy = enemy_demon_l.instance()
		1:
			enemy = enemy_demon_l.instance()
	enemy.setup(ini_pos, end_pos, player)
	enemy.connect("died", self, "on_enemy_died")
	add_child(enemy)

func on_enemy_died(size, pos):
	var points = points_scene.instance()
	score += size * 10
	score_label.text = "%03d" % score
	points.setup(size * 10, pos)
	add_child(points)
