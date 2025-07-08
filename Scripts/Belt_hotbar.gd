extends Area2D

@onready var global = get_node("/root/Global")

func _on_mouse_entered_belt(area):
	if area.has_meta("Belt"):
		global.mouse_entered_belt = true
		print("enter")


func _on_mouse_exited_belt(area):
	pass
