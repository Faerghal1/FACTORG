extends Camera2D

@onready var timer: Timer = $Timer

var temppos_y: float = 500.0 * 8
var temppos_x: float = 500.0 * 8
var move_y: bool = true
var move_x: bool = true
const POSITION_Y:float = 128.0
const POSITION_X:float = 128.0
const FASTER_TIMER: float = 0.01
const SLOWER_TIMER: float = 0.1
const MAX_UPPER: float = 7300
const MAX_LOWER: float = 1000

func _process(_delta):
	if Input.is_action_pressed("Shift"):
		timer.wait_time = FASTER_TIMER
	else:
		timer.wait_time = SLOWER_TIMER
	if Input.is_action_pressed("Up") and move_y and position.y > MAX_LOWER:
		timer.start()
		temppos_y = position.y - POSITION_Y
		move_y = false


	if Input.is_action_pressed("Down") and move_y and position.y < MAX_UPPER:
		timer.start()
		temppos_y = position.y + POSITION_Y
		move_y = false
	if Input.is_action_pressed("Right") and move_x and position.x < MAX_UPPER:
		timer.start()
		temppos_x = position.x + POSITION_X
		move_x = false
	if Input.is_action_pressed("Left") and move_x and position.x > MAX_LOWER:
		timer.start()
		temppos_x = position.x - POSITION_X
		move_x = false
	position.y = lerp(position.y,temppos_y, 0.1)
	position.x = lerp(position.x,temppos_x, 0.1)


func _on_timer_timeout():
	move_y = true
	move_x = true
