extends AudioStreamPlayer

onready var tween : Tween = $Tween

func _ready():
	tween.connect("tween_all_completed", self, "on_tween_all_completed")

func play_music():
	play()
	tween.interpolate_property(self, "volume_db", -21, -8, 0.5)
	tween.start()

func stop_music():
	tween.interpolate_property(self, "volume_db", -8, -21, 0.5)
	tween.start()

func on_tween_all_completed():
	if volume_db == -21:
		stop()
