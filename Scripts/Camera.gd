extends Camera2D

const POSITION_Y := 128.0
const POSITION_X := 128.0
var temppos_y := 10000.0 * 25/3
var temppos_x := 10000.0 * 25/3
var move_y = true
var move_x = true

func _process(delta):
	if Input.is_action_pressed("Shift"):
		$Timer.wait_time = 0.01
	else:
		$Timer.wait_time = 0.1

	if Input.is_action_pressed("Up") and move_y:
		$Timer.start()
		temppos_y = position.y - POSITION_Y
		move_y = false
	if Input.is_action_pressed("Down") and move_y:
		$Timer.start()
		temppos_y = position.y + POSITION_Y
		move_y = false
	if Input.is_action_pressed("Right") and move_x:
		$Timer.start()
		temppos_x = position.x + POSITION_X
		move_x = false
	if Input.is_action_pressed("Left") and move_x:
		$Timer.start()
		temppos_x = position.x - POSITION_X
		move_x = false
	position.y = lerp(position.y,temppos_y, 0.1)
	position.x = lerp(position.x,temppos_x, 0.1)


func _on_timer_timeout():
	move_y = true
	move_x = true
