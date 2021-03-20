extends KinematicBody2D
class_name Enemy

export var health : int
var player : KinematicBody2D
var target : Vector2
onready var sprite : AnimatedSprite = $Sprite

func damage(value):
	health -= value
	if health <= 0:
		die()

func _physics_process(delta):
	target = player.global_position
	if target.x - global_position.x < 0 and not sprite.flip_h:
		sprite.flip_h = true
	if target.x - global_position.x > 0 and sprite.flip_h:
		sprite.flip_h = false

func setup(pos, hero):
	player = hero
	global_position = pos

func die():
	pass
