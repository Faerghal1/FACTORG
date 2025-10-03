extends Area2D

@onready var global = get_node("/root/Global")
@onready var raycast = $RayCast2D
@onready var recipe = $Recipe
@onready var recipe_list = $Recipe_list
@onready var iron_rod_recipe = $Rod
@onready var copper_foil_recipe = $Copper_foil
@onready var gold_wire_recipe = $Gold_wire

@export var rod_scene: PackedScene
@export var gold_wire_scene: PackedScene
@export var copper_foil_scene: PackedScene
var clone = 0
var direction = 0
var delete = 0
var pos = Vector2i(0,0)
var bitmap: BitMap = BitMap.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if clone == 0 and global.slot == 4:
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
		if global.slot == 4:
			show()
		else:
			hide()
		global.buildings_cant_place = false
		for i in [Vector2i.ZERO, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.ONE]:
			var map = get_tree().current_scene.get_node("Generated_map")
			var cell = map.local_to_map((position - Vector2(8, 8))/2) + i
			var data = map.get_cell_tile_data(cell)
			if data.get_custom_data("World") == "Unplaceable":
				global.buildings_cant_place = true
				break


func _on_area_entered(area):
	if clone == 1:
		if area.has_meta("Ingot") and iron_rod_recipe.visible == true \
		and not raycast.get_collider():
			var rod = rod_scene.instantiate()
			rod.position = position
			rod.modulate.a = 1
			rod.rotation = rotation
			rod.direction = rotation/90
			rod.set_meta("Rod", direction/90)
			add_sibling.call_deferred(rod)
			rod.clone = 1
		if area.has_meta("Copper_ingot") and copper_foil_recipe.visible == true \
		and not raycast.get_collider():
			var copper_foil = copper_foil_scene.instantiate()
			copper_foil.position = position
			copper_foil.modulate.a = 1
			copper_foil.rotation = rotation
			copper_foil.direction = rotation/90
			copper_foil.set_meta("Copper_foil", direction/90)
			add_sibling.call_deferred(copper_foil)
			copper_foil.clone = 1
		if area.has_meta("Gold_ingot") and gold_wire_recipe.visible == true \
		and not raycast.get_collider():
			var gold_wire = gold_wire_scene.instantiate()
			gold_wire.position = position
			gold_wire.modulate.a = 1
			gold_wire.rotation = rotation
			gold_wire.direction = rotation/90
			gold_wire.set_meta("Gold_wire", direction/90)
			add_sibling.call_deferred(gold_wire)
			gold_wire.clone = 1


func _on_mouse_entered():
	delete = 1


func _on_mouse_exited():
	delete = 0


func _on_recipe_selected():
	if clone == 1 and recipe.visible == true:
		recipe.hide()
		recipe_list.show()


func _on_iron_rod_pressed():
	iron_rod_recipe.show()
	recipe_list.hide()

func _on_gold_wire_pressed():
	gold_wire_recipe.show()
	recipe_list.hide()


func _on_copper_foil_pressed():
	copper_foil_recipe.show()
	recipe_list.hide()
