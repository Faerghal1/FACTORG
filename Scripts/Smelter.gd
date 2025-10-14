extends Area2D

@onready var global = get_node("/root/Global")
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var recipe: Button = $Recipe
@onready var recipe_list: Control = $Recipe_list
@onready var iron_ingot_recipe: Sprite2D = $Iron_ingot
@onready var copper_ingot_recipe: Sprite2D = $Copper_ingot
@onready var gold_ingot_recipe: Sprite2D = $Gold_ingot

@export var ingot_scene: PackedScene
@export var copper_ingot_scene: PackedScene
@export var gold_ingot_scene: PackedScene
var direction: int = 0
var delete: bool = false
var pos: Vector2i = Vector2i(0,0)
var clone: bool = false
const QUARTER_ROTATION: int = 90
const TILE_SIZE: int = 16


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if clone == true:
		animation.set_frame(global.frames)
	if clone == false and global.hotbar_slot == global.slot.SMELTER:
		var map = get_tree().current_scene.get_node("Generated_map")
		var cell = map.local_to_map(position/2)
		var data = map.get_cell_tile_data(cell)
		if not data.get_custom_data("World") == "Unplaceable":
			global.buildings_large_cant_place = false
		else:
			global.buildings_large_cant_place = true
		position = get_global_mouse_position().snapped(Vector2(16,16))
	if Input.is_action_pressed("Right_click") and clone and delete:
		var pos = Vector2i(position.snapped(Vector2(16,16))/TILE_SIZE)
		global.bitmap.set_bit(pos.x, pos.y, false)
		global.bitmap.set_bit(pos.x+1, pos.y, false)
		global.bitmap.set_bit(pos.x, pos.y+1, false)
		global.bitmap.set_bit(pos.x+1, pos.y+1, false)
		queue_free()
	if clone == false:
		if global.hotbar_slot == global.slot.SMELTER:
			show()
		else:
			hide()


func _on_area_entered(area):
	if clone == true:
		if area.has_meta("Resource") and iron_ingot_recipe.visible == true \
		and not raycast.get_collider():
			var ingot = ingot_scene.instantiate()
			ingot.position = position
			ingot.modulate.a = 1
			ingot.rotation = rotation
			ingot.direction = rotation/QUARTER_ROTATION
			ingot.set_meta("Ingot", direction/QUARTER_ROTATION)
			add_sibling.call_deferred(ingot)
		if area.has_meta("Copper") and copper_ingot_recipe.visible == true \
		and not raycast.get_collider():
			var copper_ingot = copper_ingot_scene.instantiate()
			copper_ingot.position = position
			copper_ingot.modulate.a = 1
			copper_ingot.rotation = rotation
			copper_ingot.direction = rotation/QUARTER_ROTATION
			copper_ingot.set_meta("Copper_ingot", direction/QUARTER_ROTATION)
			add_sibling.call_deferred(copper_ingot)
		if area.has_meta("Gold") and gold_ingot_recipe.visible == true \
		and not raycast.get_collider():
			var gold_ingot = gold_ingot_scene.instantiate()
			gold_ingot.position = position
			gold_ingot.modulate.a = 1
			gold_ingot.rotation = rotation
			gold_ingot.direction = rotation/QUARTER_ROTATION
			gold_ingot.set_meta("Gold_ingot", direction/QUARTER_ROTATION)
			add_sibling.call_deferred(gold_ingot)


func _on_mouse_entered():
	delete = true


func _on_mouse_exited():
	delete = false


func _on_recipe_selected():
	if clone == true and recipe.visible == true:
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
