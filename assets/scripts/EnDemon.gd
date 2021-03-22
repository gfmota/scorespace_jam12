extends Enemy

func _physics_process(delta):
	if not in_knockback:
		motion += global_position.direction_to(target).normalized() * ACCELERATION * delta
		motion = motion.clamped(speed)
		motion *= FRICTION
	move_and_slide(motion)
