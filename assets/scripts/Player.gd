extends KinematicBody2D

signal damaged
signal shoot_projectile
const ACCELERATION : int = 1500
const MAX_SPEED : int = 2500
const FRICTION : float = 0.9
var knockback_dir : Vector2
onready var act_energies : Array = [1, 1, 1]
onready var ind_energy : int = 0
onready var is_knocking : bool = false
onready var knockback_timer : Timer = $KnockbackTimer
onready var hitbox : Area2D = $Hitbox
onready var energies_node : Node2D = $Energies
onready var energies : Array = [$Energies/Energy1, $Energies/Energy2, $Energies/Energy3]
onready var speed : Vector2 = Vector2.ZERO
onready var shoot_cooldown : Timer = $ShootCD
onready var sprite : AnimatedSprite = $Sprite
onready var tween : Tween = $Tween

func _ready():
	hitbox.connect("body_entered", self, "on_hitbox_body_entered")
	knockback_timer.connect("timeout", self, "on_knockback_ended")
	
	tween.interpolate_property(energies_node, "rotation_degrees", 0, 360, 2)
	for energy in energies:
		tween.interpolate_property(energy, "rotation_degrees", 0, -360, 2)
	tween.start()

func _physics_process(delta):
	var direction : Vector2 = Vector2.ZERO
	if not is_knocking:
		if Input.is_action_pressed("right"):
			direction += Vector2.RIGHT
		if Input.is_action_pressed("left"):
			direction += Vector2.LEFT
		if Input.is_action_pressed("up"):
			direction += Vector2.UP
		if Input.is_action_pressed("down"):
			direction += Vector2.DOWN
		
		if direction == Vector2.ZERO:
			sprite.play("idle")
		elif sprite.animation != "run":
				sprite.play("run")
	
	else:
		direction = knockback_dir
		
		sprite.play("damage")
	
	direction = direction.normalized() * 3 if is_knocking else direction.normalized()
	speed += direction * ACCELERATION * delta
	speed = speed.clamped(MAX_SPEED)
	speed *= FRICTION
	move_and_slide(speed)
	
	var mouse_pos : Vector2 = get_global_mouse_position()
	if mouse_pos.x - global_position.x < 0 and not sprite.flip_h:
		sprite.flip_h = true
	elif mouse_pos.x - global_position.x > 0 and sprite.flip_h:
		sprite.flip_h = false

func _input(event):
	if event.is_action_pressed("left_mouse") and shoot_cooldown.is_stopped():
		var color = Vector3(0, 0, 0)
		for energy in act_energies:
			match energy:
				1:
					color.x += 1
				2:
					color.y += 1
				3:
					color.z += 1
		emit_signal("shoot_projectile", color)
		shoot_cooldown.wait_time = 0.3 - 0.05 * color.y
		shoot_cooldown.start()
	
	if event.is_action_pressed("green_energy"):
		energy_manager(1)
	if event.is_action_pressed("blue_energy"):
		energy_manager(2)
	if event.is_action_pressed("red_energy"):
		energy_manager(3)

func on_hitbox_body_entered(body):
	if not is_knocking and body is Enemy:
		emit_signal("damaged")
		knockback_dir = global_position - body.global_position
		knockback_timer.start()
		sprite.play("damage")
		is_knocking = true

func on_knockback_ended():
	if get_parent().health == 0:
		call_deferred("free")
	is_knocking = false

func energy_manager(color):
	act_energies[ind_energy] = color
	match color:
		1:
			energies[ind_energy].play("green")
		2:
			energies[ind_energy].play("blue")
		3:
			energies[ind_energy].play("red")
	ind_energy += 1
	if ind_energy == 3:
		ind_energy = 0
