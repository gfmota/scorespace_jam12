extends KinematicBody2D

const ACCELERATION : int = 1500
const MAX_SPEED : int = 2500
const FRICTION : float = 0.9
onready var speed : Vector2 = Vector2.ZERO
onready var sprite : AnimatedSprite = $Sprite
onready var staff : Node2D = $Staff

func _ready():
	pass

func _physics_process(delta):
	var direction : Vector2 = Vector2.ZERO
	if Input.is_action_pressed("right"):
		direction += Vector2.RIGHT
	if Input.is_action_pressed("left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("up"):
		direction += Vector2.UP
	if Input.is_action_pressed("down"):
		direction += Vector2.DOWN
	
	speed += direction.normalized() * ACCELERATION * delta
	speed = speed.clamped(MAX_SPEED)
	speed = speed * FRICTION
	move_and_slide(speed)
	
	if direction == Vector2.ZERO:
		sprite.play("idle")
	elif sprite.animation != "run":
			sprite.play("run")
	
	var mouse_pos : Vector2 = get_global_mouse_position()
	staff.look_at(mouse_pos)
	if mouse_pos.x - global_position.x < 0 and not staff.get_node("Sprite").flip_v:
		staff.get_node("Sprite").flip_v = true
		sprite.flip_h = true
	elif mouse_pos.x - global_position.x > 0 and staff.get_node("Sprite").flip_v:
		staff.get_node("Sprite").flip_v = false
		sprite.flip_h = false
