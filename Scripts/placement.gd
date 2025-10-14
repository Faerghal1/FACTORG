extends CPUParticles2D


func _ready():
	emitting = true


func _process(_delta: float) -> void:
	if !emitting:
		queue_free()
