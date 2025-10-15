extends Area2D

@onready var global: Node = get_node("/root/Global")
@onready var raycast: RayCast2D = $RayCast2D

@export var resource_scene: PackedScene
@export var copper_scene: PackedScene
@export var gold_scene: PackedScene
var clone: bool = false
var direction: int = 0
var delete: bool = false
var bitmap: BitMap = BitMap.new()
var is_copper: bool = false
var is_iron: bool = false
var is_gold: bool= false
const QUARTER_ROTATION: int = 90
const TILE_SIZE: int = 16
const TILE_OFFSET: int = 8
const MAP_OFFSET: int = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	# Checks what resource node Extracor occupies when Extractor is placed in-world
	var map = get_tree().current_scene.get_node("Generated_map")
	var cell = map.local_to_map(position / MAP_OFFSET)
	var data = map.get_cell_tile_data(cell)
	if data.get_custom_data("Resource") == "Iron":
		is_iron = true
	if data.get_custom_data("Resource") == "Copper":
		is_copper = true
	if data.get_custom_data("Resource") == "Gold":
		is_gold = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Checks if the user has selected Belt
	if clone == false and global.hotbar_slot == global.slot.EXTRACTOR:
		var map = get_tree().current_scene.get_node("Generated_map")
		var cell = map.local_to_map(position / MAP_OFFSET)
		var data = map.get_cell_tile_data(cell)
		# Checks the tile Extractor is hovering over and not a resource node don't allow placement
		if (
				data.get_custom_data("Resource") == "Iron"
				or data.get_custom_data("Resource") == "Copper"
				or data.get_custom_data("Resource") == "Gold"
		):
			global.extractor_cant_place = false
		else:
			global.extractor_cant_place = true
		position = (get_global_mouse_position() \
		- Vector2.ONE * TILE_OFFSET).snapped(Vector2(16,16))
		position += Vector2.ONE * TILE_OFFSET
	# Controls the rotation of the Extractor before placement
	if Input.is_action_just_pressed("Rotate(R)") and clone == false:
		rotation_degrees += QUARTER_ROTATION
	# Controls the deletion of placed Extractors and deletion of the bitmap Extractor occupied
	if Input.is_action_pressed("Right_click") and clone and delete:
		var pos = Vector2i(position.snapped(Vector2(16,16)) / TILE_SIZE)
		global.bitmap.set_bit(pos.x, pos.y, false)
		position = (get_global_mouse_position() \
		- Vector2.ONE * TILE_OFFSET).snapped(Vector2(16,16))
		position += Vector2.ONE * TILE_OFFSET
		queue_free()
	# Shows or hides the Extractor that follows the users cursor
	if clone == false:
		if global.hotbar_slot == global.slot.EXTRACTOR:
			show()
		else:
			hide()


# Resources generate every 2 seconds
func _on_timer_timeout():
	if clone == true:
		# Instantiates Iron_ore resource
		if (
				global.extractor_placed == true
				and not raycast.get_collider() 
				and is_iron == true
		):
			var resource = resource_scene.instantiate()
			resource.position = position
			resource.modulate.a = 1
			resource.rotation = rotation
			resource.direction = rotation/QUARTER_ROTATION
			resource.set_meta("Resource", direction/QUARTER_ROTATION)
			add_sibling(resource)
		# Instantiates Copper_ore resource
		if (
				global.extractor_placed == true
				and not raycast.get_collider() 
				and is_copper == true
		):
			var copper = copper_scene.instantiate()
			copper.position = position
			copper.modulate.a = 1
			copper.rotation = rotation
			copper.direction = rotation/QUARTER_ROTATION
			copper.set_meta("Copper", direction/QUARTER_ROTATION)
			add_sibling(copper)
		# Instantiates Gold_ore resource
		if (
				global.extractor_placed == true
				and not raycast.get_collider() 
				and is_gold == true
		):
			var gold = gold_scene.instantiate()
			gold.position = position
			gold.modulate.a = 1
			gold.rotation = rotation
			gold.direction = rotation/QUARTER_ROTATION
			gold.set_meta("Gold", direction/QUARTER_ROTATION)
			add_sibling(gold)


func _on_mouse_entered():
	delete = true


func _on_mouse_exited():
	delete = false
