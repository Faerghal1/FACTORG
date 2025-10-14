extends Area2D

@onready var global: Node = get_node("/root/Global")
@onready var stored_amount: Label = $StoredAmount
@onready var stored_sprite: AnimatedSprite2D = $StoredSprite

var clone: bool = false
var direction: int = 0
var delete: bool = false
var pos: Vector2i = Vector2i(0,0)
var bitmap: BitMap = BitMap.new()
var item_type: int = 0
var amount: int = 1
var has_item: bool = false
const QUARTER_ROTATION: int = 90


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if clone == false and global.hotbar_slot == global.slot.STORAGE:
		var map = get_tree().current_scene.get_node("Generated_map")
		var cell = map.local_to_map(position/2)
		var data = map.get_cell_tile_data(cell)
		if not data.get_custom_data("World") == "Unplaceable":
			global.buildings_cant_place = false
		else:
			global.buildings_cant_place = true
		position = (get_global_mouse_position() - Vector2.ONE * 8).snapped(Vector2(16,16))
		position += Vector2.ONE * 8
	if Input.is_action_just_pressed("Rotate(R)") and clone == false:
		rotation_degrees += QUARTER_ROTATION
	if Input.is_action_pressed("Right_click") and clone and delete:
		queue_free()
	if clone == false:
		if global.hotbar_slot == global.slot.STORAGE:
			show()
		else:
			hide()


func _on_area_entered(area):
	if area.has_meta("Type") and clone == true:
		stored_amount.text = (str(int(amount)))
		if not has_item:
			has_item = true
			stored_sprite.show()
			item_type = area.get_meta("Type")
			stored_sprite.frame = area.get_meta("Type")
			amount += 1
		else:
			amount += 1


func _on_mouse_entered():
	delete = true


func _on_mouse_exited():
	delete = false
