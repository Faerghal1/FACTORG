extends Area2D

@onready var global = get_node("/root/Global")

var clone = 0
var direction = 0
var delete = 0
var pos = Vector2i(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_meta("Direction"))
	pos = Vector2i(position.x + 8,position.y + 8)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if global.extractor == true:
		position = get_global_mouse_position().snapped(Vector2(16,16))
		position.x -= 8
		position.y -= 8
	if Input.is_action_just_pressed("Rotate(R)") and not clone:
		rotation_degrees += 90
	if Input.is_action_pressed("Right_click") and clone and delete == 1:
		queue_free()


func _on_mouse_entered():
	delete = 1


func _on_mouse_exited():
	delete = 0


func _generation(_delta):
	$Timer.start()

func _resource():
	global.basic_resource = 1
	print(global.basic_resource)
