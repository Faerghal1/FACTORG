extends Area2D


var move = 0
func _process(_delta):
	if move == 1:	
		move_local_x(50)
		move = 0

func _on_belt_entered(area):
	if area.has_meta("Direction") and area.get_meta("Direction")>=0:
		print(area.get_meta("Direction"),"directionmeta")
		move = 1
		var dir = area.get_meta("Direction")
		rotation_degrees = dir*90

func _on_area_exited(area):
	if area.has_meta("Direction"):
		move = 0
