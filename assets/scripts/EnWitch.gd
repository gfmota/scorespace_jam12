extends Enemy

signal witch_shoot
export var shoot_scene : PackedScene
onready var shoot_cd : Timer = $ShootCD

func _ready():
	shoot_cd.connect("timeout", self, "on_shoot_cd_timeout")

func on_shoot_cd_timeout():
	emit_signal("witch_shoot", global_position)
