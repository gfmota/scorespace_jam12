extends KinematicBody2D

const ACCELERATION : int = 1500
const MAX_SPEED : int = 2500
const FRICTION : float = 0.9
onready var casting : bool = false
onready var act_energy : int = 0
onready var energies_node : Node2D = $Energies
onready var energies : Array = [$Energies/Energy1, $Energies/Energy2, $Energies/Energy3]
onready var speed : Vector2 = Vector2.ZERO
onready var spell_a_cooldown : Timer = $CooldownA
onready var spell_b_cooldown : Timer = $CooldownB
onready var sprite : AnimatedSprite = $Sprite
onready var tween : Tween = $Tween

func _ready():
	tween.interpolate_property(energies_node, "rotation_degrees", 0, 360, 2)
	for energy in energies:
		tween.interpolate_property(energy, "rotation_degrees", 0, -360, 2)
	tween.start()

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
	if mouse_pos.x - global_position.x < 0 and not sprite.flip_h:
		sprite.flip_h = true
	elif mouse_pos.x - global_position.x > 0 and sprite.flip_h:
		sprite.flip_h = false

func _input(event):
	if event.is_action_pressed("left_mouse") and spell_a_cooldown.is_stopped():
		# Cast spell A
		spell_a_cooldown.start()
	if event.is_action_pressed("right_mouse") and spell_b_cooldown.is_stopped():
		#Cast spell B
		spell_b_cooldown.start()
	
	if event.is_action_pressed("green_energy"):
		energy_manager("green")
	if event.is_action_pressed("blue_energy"):
		energy_manager("blue")
	if event.is_action_pressed("red_energy"):
		energy_manager("red")

func energy_manager(color):
	energies[act_energy].play(color)
	act_energy += 1
	if act_energy == 3:
		act_energy = 0
