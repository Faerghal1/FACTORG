extends Area2D

@onready var global = get_node("/root/Global")
@onready var animation = $AnimatedSprite2D
@onready var raycast = $RayCast2D
@onready var recipe = $Recipe
@onready var recipe_list = $Recipe_list
@onready var circuit_board_recipe = $Circuit_board
@onready var metal_frame_recipe = $Metal_frame

@export var circuit_board_scene: PackedScene
@export var metal_frame_scene: PackedScene
var clone = 0
var direction = 0
var delete = 0
var pos = Vector2i(0,0)
var wire = false
var foil = false
var rod = false
var ingot = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if wire == true and foil == true \
	and circuit_board_recipe.visible == true and not raycast.get_collider():
		var circuit_board = circuit_board_scene.instantiate()
		circuit_board.position = position
		circuit_board.modulate.a = 1
		circuit_board.rotation = rotation
		circuit_board.direction = rotation/90
		circuit_board.set_meta("Circuit_board", direction/90)
		add_sibling.call_deferred(circuit_board)
		circuit_board.clone = 1
		wire = false
		foil = false
	if rod == true and ingot == true \
	and metal_frame_recipe.visible == true and not raycast.get_collider():
		var metal_frame = metal_frame_scene.instantiate()
		metal_frame.position = position
		metal_frame.modulate.a = 1
		metal_frame.rotation = rotation
		metal_frame.direction = rotation/90
		metal_frame.set_meta("Metal_frame", direction/90)
		add_sibling.call_deferred(metal_frame)
		metal_frame.clone = 1
		rod = false
		ingot = false
	if clone == 1:
		animation.set_frame(global.frames)
	if clone == 0 and global.slot == 6:
		var map = get_tree().current_scene.get_node("Generated_map")
		var cell = map.local_to_map(position/2)
		var data = map.get_cell_tile_data(cell)
		if not data.get_custom_data("World") == "Unplaceable":
			global.buildings_large_cant_place = false
		else:
			global.buildings_large_cant_place = true
		position = get_global_mouse_position().snapped(Vector2(16,16))
		position.x -= 8
		position.y -= 8
	if Input.is_action_pressed("Right_click") and clone and delete == 1:
		var pos = Vector2i(position.snapped(Vector2(16,16))/16)
		global.bitmap.set_bit(pos.x, pos.y, false)
		global.bitmap.set_bit(pos.x+1, pos.y, false)
		global.bitmap.set_bit(pos.x, pos.y+1, false)
		global.bitmap.set_bit(pos.x+1, pos.y+1, false)
		global.bitmap.set_bit(pos.x-1, pos.y, false)
		global.bitmap.set_bit(pos.x-1, pos.y+1, false)
		global.bitmap.set_bit(pos.x-1, pos.y-1, false)
		global.bitmap.set_bit(pos.x, pos.y-1, false)
		global.bitmap.set_bit(pos.x+1, pos.y-1, false)
		queue_free()
	if clone == 0:
		if global.slot == 6:
			show()
		else:
			hide()


func _on_area_entered(area):
	if clone == 1:
		if area.has_meta("Wire"):
			wire = true
		if area.has_meta("Foil"):
			foil = true
		if area.has_meta("Rod"):
			rod = true
		if area.has_meta("Ingot"):
			ingot = true


func _on_mouse_entered():
	delete = 1


func _on_mouse_exited():
	delete = 0


func _on_recipe_selected():
	if clone == 1 and recipe.visible == true:
		recipe.hide()
		recipe_list.show()


func _on_circuit_board_pressed():
	circuit_board_recipe.show()
	recipe_list.hide()


func _on_metal_frame_pressed():
	metal_frame_recipe.show()
	recipe_list.hide()
