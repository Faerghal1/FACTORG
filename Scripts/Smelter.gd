extends Area2D

@onready var global = get_node("/root/Global")

@export var ingot_scene: PackedScene
var clone = 0
var direction = 0
var delete = 0
var pos = Vector2i(0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if clone == 0 and global.smelter == true:
		position = get_global_mouse_position().snapped(Vector2(16,16))
	if Input.is_action_just_pressed("Rotate(R)") and not clone:
		rotation_degrees += 90
	if Input.is_action_pressed("Right_click") and clone and delete == 1:
		var pos = Vector2i(position.snapped(Vector2(16,16))/16)
		global.bitmap.set_bit(pos.x, pos.y, true)
		global.bitmap.set_bit(pos.x+1, pos.y, true)
		global.bitmap.set_bit(pos.x, pos.y+1, true)
		global.bitmap.set_bit(pos.x+1, pos.y+1, true)
		queue_free()
	if clone == 0:
		if global.slot == 0:
			hide()
		if global.slot == 2:
			hide()
		if global.slot == 1:
			hide()
		if global.slot == 3:
			show()
		if global.slot == 4:
			hide()
		if global.slot == 5:
			hide()


func _on_area_entered(area):
	if area.has_meta("Direction_resource") and $Ingot.visible == true:
		var ingot = ingot_scene.instantiate()
		ingot.position = position
		ingot.modulate.a = 1
		ingot.rotation = rotation
		ingot.direction = rotation/90
		ingot.set_meta("Direction_ingot", direction/90)
		add_sibling.call_deferred(ingot)
		ingot.clone = 1
		ingot.show()


func _on_mouse_entered():
	delete = 1


func _on_mouse_exited():
	delete = 0


func _on_recipe_selected():
	if clone == 1 and $Recipe.visible == true:
		$Recipe.hide()
		$Ingot.show()
