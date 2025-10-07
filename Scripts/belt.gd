extends Area2D

@onready var global = get_node("/root/Global")
@onready var animation = $AnimatedSprite2D

var clone = 0
var direction = 0
var delete = 0
var pos = Vector2i(0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):# Sets the frames of the belt. It's globally linked 
	if clone == 1:
		animation.set_frame(global.frames)
	if clone == 0 and global.slot == 1:
		var map = get_tree().current_scene.get_node("Generated_map")
		var cell = map.local_to_map(position/2)
		var data = map.get_cell_tile_data(cell)
		if not data.get_custom_data("World") == "Unplaceable":
			global.buildings_cant_place = false
		else:
			global.buildings_cant_place = true
		position = get_global_mouse_position().snapped(Vector2(16,16))
		position.x -= 8
		position.y -= 8
	if Input.is_action_just_pressed("Rotate(R)") and not clone:
		rotation_degrees += 90
	if Input.is_action_pressed("Right_click") and clone and delete == 1:
		queue_free()
	if clone == 0:
		if global.slot == 1:
			show()
		else:
			hide()


func _on_mouse_entered():
	delete = 1


func _on_mouse_exited():
	delete = 0
