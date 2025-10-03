extends Area2D

@onready var global = get_node("/root/Global")
@onready var animation = $AnimatedSprite2D
@onready var raycast = $RayCast2D
@onready var recipe = $Recipe
@onready var recipe_list = $Recipe_list
@onready var iron_ingot_recipe = $Iron_ingot
@onready var copper_ingot_recipe = $Copper_ingot
@onready var gold_ingot_recipe = $Gold_ingot

@export var ingot_scene: PackedScene
@export var copper_ingot_scene: PackedScene
@export var gold_ingot_scene: PackedScene
var clone = 0
var direction = 0
var delete = 0
var pos = Vector2i(0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if clone == 1:
		animation.set_frame(global.frames)
	if clone == 0 and global.slot == 3:
		var map = get_tree().current_scene.get_node("Generated_map")
		var cell = map.local_to_map(position/2)
		var data = map.get_cell_tile_data(cell)
		if not data.get_custom_data("World") == "Unplaceable":
			global.buildings_large_cant_place = false
		else:
			global.buildings_large_cant_place = true
		position = get_global_mouse_position().snapped(Vector2(16,16))
	if Input.is_action_pressed("Right_click") and clone and delete == 1:
		var pos = Vector2i(position.snapped(Vector2(16,16))/16)
		global.bitmap.set_bit(pos.x, pos.y, false)
		global.bitmap.set_bit(pos.x+1, pos.y, false)
		global.bitmap.set_bit(pos.x, pos.y+1, false)
		global.bitmap.set_bit(pos.x+1, pos.y+1, false)
		queue_free()
	if clone == 0:
		if global.slot == 3:
			show()
		else:
			hide()


func _on_area_entered(area):
	if clone == 1:
		if area.has_meta("Resource") and iron_ingot_recipe.visible == true \
		and not raycast.get_collider():
			var ingot = ingot_scene.instantiate()
			ingot.position = position
			ingot.modulate.a = 1
			ingot.rotation = rotation
			ingot.direction = rotation/90
			ingot.set_meta("Ingot", direction/90)
			add_sibling.call_deferred(ingot)
			ingot.clone = 1
		if area.has_meta("Copper") and copper_ingot_recipe.visible == true \
		and not raycast.get_collider():
			var copper_ingot = copper_ingot_scene.instantiate()
			copper_ingot.position = position
			copper_ingot.modulate.a = 1
			copper_ingot.rotation = rotation
			copper_ingot.direction = rotation/90
			copper_ingot.set_meta("Copper_ingot", direction/90)
			add_sibling.call_deferred(copper_ingot)
			copper_ingot.clone = 1
		if area.has_meta("Gold") and gold_ingot_recipe.visible == true \
		and not raycast.get_collider():
			var gold_ingot = gold_ingot_scene.instantiate()
			gold_ingot.position = position
			gold_ingot.modulate.a = 1
			gold_ingot.rotation = rotation
			gold_ingot.direction = rotation/90
			gold_ingot.set_meta("Gold_ingot", direction/90)
			add_sibling.call_deferred(gold_ingot)
			gold_ingot.clone = 1


func _on_mouse_entered():
	delete = 1


func _on_mouse_exited():
	delete = 0


func _on_recipe_selected():
	if clone == 1 and recipe.visible == true:
		recipe.hide()
		recipe_list.show()


func _on_iron_ingot_pressed():
	iron_ingot_recipe.show()
	recipe_list.hide()


func _on_copper_ingot_pressed():
	copper_ingot_recipe.show()
	recipe_list.hide()


func _on_gold_ingot_pressed():
	gold_ingot_recipe.show()
	recipe_list.hide()
