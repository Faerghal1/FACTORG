extends Area2D

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
		move_local_x(16)
		move = 0


func _on_belt_entered(area):
	if area.has_meta("Direction_belt") and area.get_meta("Direction_belt")>=0:
		move = 1
		var dir = area.get_meta("Direction_belt")
		rotation_degrees = dir*90


func _on_area_exited(area):
	if area.has_meta("Direction_belt"):
		move = 0


func _on_ready():
	move_local_y(16)
