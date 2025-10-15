extends Area2D

@onready var global: Node = get_node("/root/Global")
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var direction: int = 0
var delete: bool = false
var clone: bool = false
const QUARTER_ROTATION: int = 90
const TILE_OFFSET: int = 8
const MAP_OFFSET: int = 2
const TILE_SIZE: int = 16


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Controls Belt animation. It's globally linked with all other placeables
	if clone == true:
		animation.set_frame(global.frames)
	# Checks if the user has selected Belt
	if clone == false and global.hotbar_slot == global.slot.BELT:
		var map = get_tree().current_scene.get_node("Generated_map")
		var cell = map.local_to_map(position / MAP_OFFSET)
		var data = map.get_cell_tile_data(cell)
		# Checks the tile Belt is hovering over and if water or mountain don't allow placement
		if not data.get_custom_data("World") == "Unplaceable":
			global.buildings_cant_place = false
		else:
			global.buildings_cant_place = true
		position = (get_global_mouse_position() \
		- Vector2.ONE * TILE_OFFSET).snapped(Vector2(16,16))
		position += Vector2.ONE * TILE_OFFSET
	# Controls the rotation of the Belt before placement
	if Input.is_action_just_pressed("Rotate(R)") and clone == false:
		rotation_degrees += QUARTER_ROTATION
	# Controls the deletion of placed Belts and deletion of the bitmap Belt occupied
	if Input.is_action_pressed("Right_click") and clone and delete:
		var pos = Vector2i(position.snapped(Vector2(16,16)) / TILE_SIZE)
		global.bitmap.set_bit(pos.x, pos.y, false)
		position = (get_global_mouse_position() \
		- Vector2.ONE * TILE_OFFSET).snapped(Vector2(16,16))
		position += Vector2.ONE * TILE_OFFSET
		queue_free()
	# Shows or hides the Belt that follows the users cursor
	if clone == false:
		if global.hotbar_slot == global.slot.BELT:
			show()
		else:
			hide()


func _on_mouse_entered():
	delete = true


func _on_mouse_exited():
	delete = false
