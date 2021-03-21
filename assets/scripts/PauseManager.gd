extends Node2D

onready var black_filter : ColorRect = $ColorRect

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		black_filter.visible = !black_filter.visible
