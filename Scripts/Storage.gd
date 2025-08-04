extends Area2D

@onready var global = get_node("/root/Global")

var clone = 0
var direction = 0
var delete = 0
var pos = Vector2i(0,0)
var bitmap: BitMap = BitMap.new()
var item_type = ""
var amount = 1
var has_item = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if clone == 0 and global.slot == 5:
		position = get_global_mouse_position().snapped(Vector2(16,16))
		position.x -= 8
		position.y -= 8
	if Input.is_action_just_pressed("Rotate(R)") and not clone:
		rotation_degrees += 90
	if Input.is_action_pressed("Right_click") and clone and delete == 1:
		queue_free()
	if clone == 0:
		if global.slot == 5:
			show()
		else:
			hide()


func _on_area_entered(area):
	if area.has_meta("Type") and clone == 1:
		$ResourceAmount.text = (str(int(amount)))
		if not has_item:
			has_item = true
			item_type = area.get_meta("Type")
			amount += 1
		elif item_type == area.get_meta("Type"):
			if area.get_meta("Type") == "Direction Resource":
				$Iron_Ore.show()
				print("Iron")
				amount += 1
			if area.get_meta("Type") == "Direction Ingot":
				$Iron_Ingot.show()
				print("Iron_Ingot")
				amount += 1
			if area.get_meta("Type") == "Direction Rod":
				$Iron_Rod.show()
				print("Iron_Rod")
				amount += 1
			if area.get_meta("Type") == "Direction Copper":
				$Copper_Ore.show()
				print("Copper")
				amount += 1
			if area.get_meta("Type") == "Direction Copper Ingot":
				$Copper_ingot.show()
				print("Copper_Ingot")
				amount += 1


func _on_mouse_entered():
	delete = 1


func _on_mouse_exited():
	delete = 0


func _on_body_entered(_body):
	if clone == 0:
		var map = get_tree().current_scene.get_node("Generated_map")
		var cell = map.local_to_map(position/2)
		var data = map.get_cell_tile_data(cell)
		if not data.get_custom_data("World") == "Unplaceable":
			global.buildings_cant_place = false
		else:
			global.buildings_cant_place = true
