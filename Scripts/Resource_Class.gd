extends Node
class_name ResourceClass

var delete = 0


func _process(_delta):
	if Input.is_action_pressed("Right_click") and delete == 1:
		print("hello")
		get_parent().queue_free()


func _on_mouse_entered():
	delete = 1


func _on_mouse_exited():
	delete = 0
