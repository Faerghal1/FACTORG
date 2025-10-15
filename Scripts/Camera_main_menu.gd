extends Camera2D

var temppos_y: float = 100.0 * 8
var temppos_x: float = 300.0 * 8
const POSITION_Y: float = 128.0
const POSITION_X: float = 128.0
const TILE_OFFSET: int = 8


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	temppos_x = position.x + TILE_OFFSET
	position.y = lerp(position.y,temppos_y, 0.1)
	position.x = lerp(position.x,temppos_x, 0.1)
