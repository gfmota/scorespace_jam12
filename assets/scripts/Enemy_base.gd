extends KinematicBody2D
class_name Enemy

signal died
export var health : int
export var size : int
export var speed : int
export var weight : float
var knockback_dir : Vector2
var player : KinematicBody2D
var position_ini : Vector2
var position_end : Vector2
var motion : Vector2
var target : Vector2
onready var damaged_sfx : AudioStreamPlayer2D = $DamagedSFX
onready var in_knockback : bool = false
onready var knockback_timer : Timer = $KnockbackTimer
onready var sprite : AnimatedSprite = $Sprite
onready var tween : Tween = $Tween

func _ready():
	tween.connect("tween_all_completed", self, "on_tween_all_completed")
	knockback_timer.connect("timeout", self, "on_knockback_timeout")
	tween.interpolate_property(self, "position:y", position_ini.y, position_end.y, 1, Tween.TRANS_BACK ,Tween.EASE_OUT if position_ini.y - position_end.y > 0 else Tween.EASE_IN)
	tween.interpolate_property(self, "position:x", position_ini.x, position_end.x, 1)
	tween.start()

func _physics_process(delta):
	if in_knockback:
		sprite.play("damage")
		motion = knockback_dir * speed * delta / weight
	
	target = player.global_position if player != null else global_position
	if target.x - global_position.x < 0 and not sprite.flip_h:
		sprite.flip_h = true
	if target.x - global_position.x > 0 and sprite.flip_h:
		sprite.flip_h = false

func setup(ini_pos, end_pos, hero):
	player = hero
	global_position = ini_pos
	position_ini = ini_pos
	position_end = end_pos

func damage(value, shoot_pos):
	if not in_knockback:
		health -= value
		knockback_dir = global_position - shoot_pos
		in_knockback = true
		knockback_timer.start()
		damaged_sfx.play()
		if health <= 0:
			tween.interpolate_property(self, "modulate:a", 1, 0, knockback_timer.wait_time, Tween.TRANS_QUINT, Tween.EASE_IN)
			tween.start()

func on_knockback_timeout():
	in_knockback = false
	sprite.play("run")

func on_tween_all_completed():
	sprite.play("run")
	if health <= 0:
		call_deferred("free")
		emit_signal("died", size, global_position)
