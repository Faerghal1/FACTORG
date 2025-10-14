extends CharacterBody2D

@onready var global: Node = get_node("/root/Global")
@onready var timer: Timer = $Timer

var direction: int = 0
var delete: bool = false
var pos: Vector2i = Vector2i(0,0)
var moving: bool = false
const QUARTER_ROTATION: int = 90


func _process(_delta):
	if moving == true:
		if not test_move(transform, Vector2(16, 0).rotated(rotation)):
			timer.start()
			moving = false
	if Input.is_action_pressed("Right_click") and delete == true:
		queue_free()


func _on_area_entered(area):
	if area.has_meta("Belt") and area.get_meta("Belt")>=0:
		moving = true
		var dir = area.get_meta("Belt")
		rotation_degrees = dir * QUARTER_ROTATION
	if area.has_meta("Combiner") and area.get_meta("Combiner")>=0:
		queue_free()
	if area.has_meta("Storage") and area.get_meta("Storage")>=0:
		global.copper_foil += 1
		queue_free()


func _on_area_exited(area):
	if area.has_meta("Direction_belt"):
		moving = false


func _on_ready():
	move_local_y(8)
	move_local_x(-24)


func _on_timer_timeout():
	move_local_x(16)
	moving = false


func _on_mouse_entered():
	delete = true


func _on_mouse_exited():
	delete = false
