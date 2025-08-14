extends CharacterBody2D

@onready var global = get_node("/root/Global")

var clone = 0
var direction = 0
var delete = 0
var pos = Vector2i(0,0)
var move = 0


func _process(_delta):
	if clone == 0:
		position.x -= 8
		position.y -= 8
	if move == 1:
		if not test_move(transform, Vector2(16, 0).rotated(rotation)):
			$Timer.start()
			move = 0
	if Input.is_action_pressed("Right_click") and clone and delete == 1:
		queue_free()

func _on_area_entered(area):
	if area.has_meta("Belt") and area.get_meta("Belt")>=0:
		move = 1
		var dir = area.get_meta("Belt")
		rotation_degrees = dir*90
	if area.has_meta("Storage") and area.get_meta("Storage")>=0:
		global.rod += 1
		queue_free()


func _on_area_exited(area):
	if area.has_meta("Belt"):
		move = 0


func _on_ready():
	move_local_y(8)
	move_local_x(-24)


func _on_timer_timeout():
	move_local_x(16)
	move = 0


func _on_mouse_entered() -> void:
	delete = 1


func _on_mouse_exited() -> void:
	delete = 0
