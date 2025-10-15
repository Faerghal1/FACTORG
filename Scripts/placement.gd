extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not emitting:
		queue_free()
