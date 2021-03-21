extends Node2D

export var enemy_demon_s : PackedScene
export var enemy_demon_m : PackedScene
export var enemy_demon_l : PackedScene
export var points_scene : PackedScene
export var shoot_scene : PackedScene
var rng = RandomNumberGenerator.new()
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var enemy_num : int = 4
onready var difficult_timer : Timer = $DifficultTimer
onready var health : int = 6
onready var hearts : Sprite = $HUD/Hearts
onready var fade : Node2D = $Fade
onready var pause_manager : Node2D = $PauseManager
onready var player : KinematicBody2D = $Player
onready var screen_shake : Node = $ScreenShake
onready var score : int = 0
onready var score_label : Label = $HUD/Label
onready var spawn_locations : Node2D = $SpawnLocations
onready var spawn_timers : Array = [$SpawnTimerL, $SpawnTimerM, $SpawnTimerS]

func _ready():
	fade.connect("end_fade_in", self, "on_end_fade_in")
	fade.connect("end_fade_out", pause_manager, "on_end_fade_out")
	player.connect("shoot_projectile", self, "on_player_shoot_projectile")
	player.connect("damaged", self, "on_player_damaged")
	difficult_timer.connect("timeout", self, "on_difficult_timer_timeout")
	for timer in spawn_timers:
		timer.start()
		timer.connect("timeout", self, "on_timeout_" + timer.name)
	
	fade.fade_in()
	animation_player.play("hud")
	InGameMusic.play_music()

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
		pause_manager.game_over(score)

func on_difficult_timer_timeout():
	enemy_num += 2

func on_timeout_SpawnTimerL():
	spawn_enemy(3)

func on_timeout_SpawnTimerM():
	spawn_enemy(2)

func on_timeout_SpawnTimerS():
	spawn_enemy(1)

func spawn_enemy(size):
	var max_iteration : int
	var enemy
	match size:
		1:
			max_iteration = enemy_num
			enemy = enemy_demon_s
		2:
			max_iteration = enemy_num / 2
			enemy = enemy_demon_m
		3:
			max_iteration = enemy_num / 4
			enemy = enemy_demon_l
	for i in range(0, max_iteration):
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
		var enemy_instance = enemy.instance()
		enemy_instance.setup(ini_pos, end_pos, player)
		enemy_instance.connect("died", self, "on_enemy_died")
		add_child(enemy_instance)

func on_enemy_died(size, pos):
	var points = points_scene.instance()
	score += size * 10
	score_label.text = str(score).pad_zeros(3)
	points.setup(size * 10, pos)
	add_child(points)
