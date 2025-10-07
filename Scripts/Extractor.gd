extends Area2D

@onready var global = get_node("/root/Global")
@onready var raycast = $RayCast2D

@export var resource_scene: PackedScene
@export var copper_scene: PackedScene
@export var gold_scene: PackedScene
var map: TileMapLayer
var clone = 0
var direction = 0
var delete = 0
var pos = Vector2i(0,0)
var bitmap: BitMap = BitMap.new()
var is_copper = false
var is_iron = false
var is_gold = false


func _ready():
	var map = get_tree().current_scene.get_node("Generated_map")
	var cell = map.local_to_map(position/2)
	var data = map.get_cell_tile_data(cell)
	if data.get_custom_data("Resource") == "Iron":
		is_iron = true
	if data.get_custom_data("Resource") == "Copper":
		is_copper = true
	if data.get_custom_data("Resource") == "Gold":
		is_gold = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if clone == 0 and global.slot == 2:
		var map = get_tree().current_scene.get_node("Generated_map")
		var cell = map.local_to_map(position/2)
		var data = map.get_cell_tile_data(cell)
		if data.get_custom_data("Resource") == "Iron" \
		or data.get_custom_data("Resource") == "Copper" \
		or data.get_custom_data("Resource") == "Gold":
			global.extractor_cant_place = false
		else:
			global.extractor_cant_place = true
		position = get_global_mouse_position().snapped(Vector2(16,16))
		position.x -= 8
		position.y -= 8
	if Input.is_action_just_pressed("Rotate(R)") and not clone:
		rotation_degrees += 90
	if Input.is_action_pressed("Right_click") and clone and delete == 1:
		queue_free()
	if clone == 0:
		if global.slot == 2:
			show()
		else:
			hide()


func _on_timer_timeout():
	if clone == 1:
		if global.extractor_placed == true \
		and not raycast.get_collider() and is_iron == true:
			var resource = resource_scene.instantiate()
			resource.position = position
			resource.modulate.a = 1
			resource.rotation = rotation
			resource.direction = rotation/90
			resource.set_meta("Resource", direction/90)
			add_sibling(resource)
			resource.clone = 1
		if global.extractor_placed == true \
		and not raycast.get_collider() and is_copper == true:
			var copper = copper_scene.instantiate()
			copper.position = position
			copper.modulate.a = 1
			copper.rotation = rotation
			copper.direction = rotation/90
			copper.set_meta("Copper", direction/90)
			add_sibling(copper)
			copper.clone = 1
		if global.extractor_placed == true \
		and not raycast.get_collider() and is_gold == true:
			var gold = gold_scene.instantiate()
			gold.position = position
			gold.modulate.a = 1
			gold.rotation = rotation
			gold.direction = rotation/90
			gold.set_meta("Gold", direction/90)
			add_sibling(gold)
			gold.clone = 1


func _on_mouse_entered():
	delete = 1


func _on_mouse_exited():
	delete = 0
