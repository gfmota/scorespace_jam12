extends AudioStreamPlayer

func _ready():
	connect("finished", self, "on_sfx_finished")

func on_sfx_finished():
	call_deferred("free")
