extends Area2D

@onready var global: Node = get_node("/root/Global")
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var direction: int = 0
var delete: bool = false
var pos: Vector2i = Vector2i(0,0)
var clone: bool = false
const QUARTER_ROTATION: int = 90
const TILE_OFFSET: int = 8


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):# Sets the frames of the belt. It's globally linked 
	if clone == true:
		animation.set_frame(global.frames)
	if clone == false and global.hotbar_slot == global.slot.BELT:
		var map = get_tree().current_scene.get_node("Generated_map")
		var cell = map.local_to_map(position/2)
		var data = map.get_cell_tile_data(cell)
		if not data.get_custom_data("World") == "Unplaceable":
			global.buildings_cant_place = false
		else:
			global.buildings_cant_place = true
		position = get_global_mouse_position().snapped(Vector2(16,16))
		position.x -= TILE_OFFSET
		position.y -= TILE_OFFSET
	if Input.is_action_just_pressed("Rotate(R)") and clone == false:
		rotation_degrees += QUARTER_ROTATION
	if Input.is_action_pressed("Right_click") and clone and delete:
		queue_free()
	if clone == false:
		if global.hotbar_slot == global.slot.BELT:
			show()
		else:
			hide()


func _on_mouse_entered():
	delete = true


func _on_mouse_exited():
	delete = false
