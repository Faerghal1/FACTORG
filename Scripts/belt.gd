extends Area2D

@onready var global = get_node("/root/Global")

var clone = 0
var direction = 0
var delete = 0
var pos = Vector2i(0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if clone == 0 and global.belt == true:
		position = get_global_mouse_position().snapped(Vector2(16,16))
		position.x -= 8
		position.y -= 8
	if Input.is_action_just_pressed("Rotate(R)") and not clone:
		rotation_degrees += 90
	if Input.is_action_pressed("Right_click") and clone and delete == 1:
		queue_free()
	if clone == 0:
		if global.slot == 2:
			hide()
		if global.slot == 1:
			show()
		if global.slot == 3:
			hide()


func _on_mouse_entered():
	delete = 1


func _on_mouse_exited():
	delete = 0


#func _on_area_entered(area):
	#if clone == 1 and area.has_meta("Direction") and area.get_meta("Direction") >=0 and not \
	#area.get_meta("Direction")%4 == get_meta("Direction")%4:
		#set_meta("Direction", area.get_meta("Direction"))
		#rotation_degrees = 90*area.get_meta("Direction")
		#print("attampt")
		#print(get_meta("Direction"), "o")
		#print(get_meta("Direction"), "f")
