extends CharacterBody2D

@onready var global: Node = get_node("/root/Global")
@onready var timer: Timer = $Timer

var direction: int = 0
var delete: bool = false
var pos: Vector2i = Vector2i(0,0)
var moving: bool = false
const QUARTER_ROTATION: int = 90


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if moving == true:
		# Stops resource from moving if collided with any other resource
		if not test_move(transform, Vector2(16, 0).rotated(rotation)):
			timer.start()
			moving = false
	# Deletes resource if the user is hovering over it and presses delete
	if Input.is_action_pressed("Right_click") and delete == true:
		queue_free()


func _on_area_entered(area):
	# When this resource has detected Belt move the resource foward in the direction of the Belt
	if area.has_meta("Belt") and area.get_meta("Belt") > 0:
		moving = true
		var dir = area.get_meta("Belt")
		rotation_degrees = dir * QUARTER_ROTATION
	# When this resource has detected Smelter delete even if recipe doens't involve resource
	if area.has_meta("Smelter") and area.get_meta("Smelter") > 0:
		queue_free()
	# When this resource has detected Storage, delete and increase global counter for resource
	if area.has_meta("Storage") and area.get_meta("Storage") > 0:
		global.iron_ore += 1
		queue_free()


# When this resource has moved off Belt stop the resource from moving
func _on_area_exited(area):
	if area.has_meta("Direction_belt"):
		moving = false


func _on_ready():
	move_local_y(16)


func _on_timer_timeout():
	move_local_x(16)
	moving = false


func _on_mouse_entered() -> void:
	delete = true


func _on_mouse_exited() -> void:
	delete = false
