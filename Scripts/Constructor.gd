extends Area2D

@onready var global = get_node("/root/Global")

var clone = 0
var direction = 0
var delete = 0
var pos = Vector2i(0,0)
var bitmap: BitMap = BitMap.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if clone == 0 and global.constructor == true:
		position = get_global_mouse_position().snapped(Vector2(16,16))
	if Input.is_action_just_pressed("Rotate(R)") and not clone:
		rotation_degrees += 90
	if Input.is_action_pressed("Right_click") and clone and delete == 1:
		queue_free()
	if clone == 0:
		if global.slot == 0:
			hide()
		if global.slot == 2:
			hide()
		if global.slot == 1:
			hide()
		if global.slot == 3:
			hide()
		if global.slot == 4:
			show()


func _on_mouse_entered():
	delete = 1


func _on_mouse_exited():
	delete = 0


func _on_recipe_selected():
	if clone == 1 and $Recipe.visible == true:
		$Recipe.hide()
