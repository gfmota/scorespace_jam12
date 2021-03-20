extends Enemy

const MAX_SPEED : int = 1000
const ACCELERATION : int = 500
const FRICTION : float = 0.9
var speed : Vector2

func _physics_process(delta):
	speed += global_position.direction_to(target).normalized() * ACCELERATION * delta
	speed = speed.clamped(MAX_SPEED)
	speed *= FRICTION
	move_and_slide(speed)
