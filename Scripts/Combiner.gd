extends Area2D

@onready var global: Node = get_node("/root/Global")
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var recipe: Button = $Recipe
@onready var recipe_list: Control = $Recipe_list
@onready var circuit_board_recipe: Sprite2D = $Circuit_board
@onready var metal_frame_recipe: Sprite2D = $Metal_frame

@export var circuit_board_scene: PackedScene
@export var metal_frame_scene: PackedScene
var clone: bool = false
var direction: int = 0
var delete: bool = false
var wire: bool = false
var foil: bool = false
var rod: bool = false
var ingot: bool = false
const QUARTER_ROTATION: int = 90
const TILE_OFFSET: int = 8
const TILE_SIZE: int = 16
const MAP_OFFSET: int = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Instantiates Circuit_board resource
	if (
			wire == true 
			and foil == true
			and circuit_board_recipe.visible == true 
			and not raycast.get_collider()
	):
		var circuit_board = circuit_board_scene.instantiate()
		circuit_board.position = position
		circuit_board.modulate.a = 1
		circuit_board.rotation = rotation
		circuit_board.direction = rotation/QUARTER_ROTATION
		circuit_board.set_meta("Circuit_board", direction/QUARTER_ROTATION)
		add_sibling.call_deferred(circuit_board)
		wire = false
		foil = false
	# Instantiates Metal_frame resource
	if (
			rod == true 
			and ingot == true
			and metal_frame_recipe.visible == true 
			and not raycast.get_collider()
	):
		var metal_frame = metal_frame_scene.instantiate()
		metal_frame.position = position
		metal_frame.modulate.a = 1
		metal_frame.rotation = rotation
		metal_frame.direction = rotation/QUARTER_ROTATION
		metal_frame.set_meta("Metal_frame", direction/QUARTER_ROTATION)
		add_sibling.call_deferred(metal_frame)
		rod = false
		ingot = false
	# Controls Combiner animation. It's globally linked with all other placeables
	if clone == true:
		animation.set_frame(global.frames)
	# Checks if the user has selected Combiner
	if clone == false and global.hotbar_slot == global.slot.COMBINER:
		var map = get_tree().current_scene.get_node("Generated_map")
		var cell = map.local_to_map(position/MAP_OFFSET)
		var data = map.get_cell_tile_data(cell)
		# Checks the tile Combiner is hovering over and if water or mountain don't allow placement
		if not data.get_custom_data("World") == "Unplaceable":
			global.buildings_large_cant_place = false
		else:
			global.buildings_large_cant_place = true
		position = get_global_mouse_position().snapped(Vector2(16,16))
		position.x -= TILE_OFFSET
		position.y -= TILE_OFFSET
	# Controls the deletion of placed Combiners and deletion of the bitmap Combiner occupied
	if Input.is_action_pressed("Right_click") and clone and delete:
		var pos = Vector2i(position.snapped(Vector2(16,16)) / TILE_SIZE)
		global.bitmap.set_bit(pos.x, pos.y, false)
		global.bitmap.set_bit(pos.x + 1, pos.y, false)
		global.bitmap.set_bit(pos.x, pos.y + 1, false)
		global.bitmap.set_bit(pos.x + 1, pos.y + 1, false)
		global.bitmap.set_bit(pos.x - 1, pos.y, false)
		global.bitmap.set_bit(pos.x - 1, pos.y + 1, false)
		global.bitmap.set_bit(pos.x - 1, pos.y - 1, false)
		global.bitmap.set_bit(pos.x, pos.y - 1, false)
		global.bitmap.set_bit(pos.x + 1, pos.y - 1, false)
		queue_free()
	# Shows or hides the Combiner that follows the users cursor
	if clone == false:
		if global.hotbar_slot == global.slot.COMBINER:
			show()
		else:
			hide()


# If resource that could be used in Combiner recipe is detected set respective variable
func _on_area_entered(area):
	if clone == true:
		if area.has_meta("Wire"):
			wire = true
		if area.has_meta("Foil"):
			foil = true
		if area.has_meta("Rod"):
			rod = true
		if area.has_meta("Ingot"):
			ingot = true


func _on_mouse_entered():
	delete = true


func _on_mouse_exited():
	delete = false


func _on_recipe_selected():
	if clone == true and recipe.visible == true:
		recipe.hide()
		recipe_list.show()


func _on_circuit_board_pressed():
	circuit_board_recipe.show()
	recipe_list.hide()


func _on_metal_frame_pressed():
	metal_frame_recipe.show()
	recipe_list.hide()
