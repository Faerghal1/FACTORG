extends Area2D

@onready var global: Node = get_node("/root/Global")
@onready var raycast: RayCast2D = $RayCast2D
@onready var recipe: Button = $Recipe
@onready var recipe_list: Control = $Recipe_list
@onready var iron_rod_recipe: Sprite2D = $Rod
@onready var copper_foil_recipe: Sprite2D = $Copper_foil
@onready var gold_wire_recipe: Sprite2D = $Gold_wire
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

@export var rod_scene: PackedScene
@export var gold_wire_scene: PackedScene
@export var copper_foil_scene: PackedScene
var clone: bool = false
var direction: int = 0
var delete: bool = false
var bitmap: BitMap = BitMap.new()
const TILE_SIZE: int = 16
const QUARTER_ROTATION: int = 90
const MAP_OFFSET: int = 2
const TILE_OFFSET: int = 8


# Called when the node enters the scene tree for the first time.
func _ready():
	# Checks what tile Constructor occupies when Constructor is placed in-world
	var map = get_tree().current_scene.get_node("Generated_map")
	var cell = map.local_to_map(position / MAP_OFFSET)
	var data = map.get_cell_tile_data(cell)
	# Detects if Constructor can't be placed and either deletes or shows the Constructor
	if data.get_custom_data("World") == "Unplaceable":
		queue_free()
	else:
		global.successful_place = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Controls Constructor animation. It's globally linked with all other placeables
	if clone == true:
		animation.set_frame(global.frames)
	# Checks if the user has selected Constructor
	if clone == false and global.hotbar_slot == global.slot.CONSTRUCTOR:
		var map = get_tree().current_scene.get_node("Generated_map")
		var cell = map.local_to_map(position / MAP_OFFSET)
		var data = map.get_cell_tile_data(cell)
		# Checks the tile Constructor is hovering over and if water or mountain don't allow placement
		if not data.get_custom_data("World") == "Unplaceable":
			global.buildings_large_cant_place = false
		else:
			global.buildings_large_cant_place = true
		position = get_global_mouse_position().snapped(Vector2(16,16))
	# Controls the deletion of placed Constructors and deletion of the bitmap Constructor occupied
	if Input.is_action_pressed("Right_click") and clone and delete:
		var pos = Vector2i(position.snapped(Vector2(16,16)) / TILE_SIZE)
		global.bitmap.set_bit(((position.x - TILE_OFFSET) 
		/ TILE_SIZE), ((position.y - TILE_OFFSET) / TILE_SIZE), false)
		global.bitmap.set_bit(((position.x + TILE_OFFSET) 
		/ TILE_SIZE), ((position.y - TILE_OFFSET) / TILE_SIZE), false)
		global.bitmap.set_bit(((position.x - TILE_OFFSET) 
		/ TILE_SIZE), ((position.y + TILE_OFFSET) / TILE_SIZE), false)
		global.bitmap.set_bit(((position.x + TILE_OFFSET) 
		/ TILE_SIZE), ((position.y + TILE_OFFSET) / TILE_SIZE), false)
		queue_free()
	# Shows or hides the Constructor that follows the users cursor
	if clone == false:
		if global.hotbar_slot == global.slot.CONSTRUCTOR:
			show()
		else:
			hide()


func _on_area_entered(area):
	if clone == true:
		# Instantiates Iron_rod resource
		if (
				area.has_meta("Ingot") 
				and iron_rod_recipe.visible == true
				and not raycast.get_collider()
		):
			var rod = rod_scene.instantiate()
			rod.position = position
			rod.modulate.a = 1
			rod.rotation = rotation
			rod.direction = rotation/QUARTER_ROTATION
			rod.set_meta("Rod", direction/QUARTER_ROTATION)
			add_sibling.call_deferred(rod)
		# Instantiates Copper_foil resource
		if (
				area.has_meta("Copper_ingot") 
				and copper_foil_recipe.visible == true
				and not raycast.get_collider()
		):
			var copper_foil = copper_foil_scene.instantiate()
			copper_foil.position = position
			copper_foil.modulate.a = 1
			copper_foil.rotation = rotation
			copper_foil.direction = rotation/QUARTER_ROTATION
			copper_foil.set_meta("Foil", direction/QUARTER_ROTATION)
			add_sibling.call_deferred(copper_foil)
		# Instantiates Gold_wire resource
		if (
				area.has_meta("Gold_ingot") 
				and gold_wire_recipe.visible == true
				and not raycast.get_collider()
		):
			var gold_wire = gold_wire_scene.instantiate()
			gold_wire.position = position
			gold_wire.modulate.a = 1
			gold_wire.rotation = rotation
			gold_wire.direction = rotation/QUARTER_ROTATION
			gold_wire.set_meta("Wire", direction/QUARTER_ROTATION)
			add_sibling.call_deferred(gold_wire)


func _on_mouse_entered():
	delete = true


func _on_mouse_exited():
	delete = false


func _on_recipe_selected():
	if clone == true and recipe.visible == true:
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
