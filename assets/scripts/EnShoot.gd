extends Node2D

var speed : int = 350
var direction : Vector2
onready var collision_area : Area2D = $Collision

func _ready():
	collision_area.connect("body_entered", self, "on_body_entered")

func _process(delta):
	position += direction * speed * delta

func setup(pos, dir):
	global_position = pos
	direction = dir
	rotation_degrees = rad2deg(dir.angle())

func on_body_entered(body):
	if body is Enemy:
		pass
	else:
		if body.is_in_group("player"):
			body.damage(self)
		call_deferred("free")
