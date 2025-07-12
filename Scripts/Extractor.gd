extends Area2D

@onready var global = get_node("/root/Global")

@export var resource_scene: PackedScene
var clone = 0
var direction = 0
var delete = 0
var pos = Vector2i(0,0)
var bitmap: BitMap = BitMap.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if clone == 0 and global.extractor == true:
		position = get_global_mouse_position().snapped(Vector2(16,16))
		position.x -= 8
		position.y -= 8
	if Input.is_action_just_pressed("Rotate(R)") and not clone:
		rotation_degrees += 90
	if Input.is_action_pressed("Right_click") and clone and delete == 1:
		queue_free()


func _on_timer_timeout():
	if clone == 1 and global.extractor_placed == true:
		var resource = resource_scene.instantiate()
		resource.position = position
		resource.modulate.a = 50
		resource.rotation_degrees = direction
		resource.direction = rotation/90
		resource.set_meta("Direction_resource", direction/90)
		add_sibling(resource)
		resource.clone = 1
		resource.show()


func _on_mouse_entered():
	delete = 1


func _on_mouse_exited():
	delete = 0
