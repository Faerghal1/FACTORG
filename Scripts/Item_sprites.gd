extends Sprite2D

const RESET_ROTATION: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	global_rotation = RESET_ROTATION


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_rotation = RESET_ROTATION
