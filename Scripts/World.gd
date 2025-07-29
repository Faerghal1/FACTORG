extends Node2D

@onready var global = get_node("/root/Global")

@export var belt_scene: PackedScene
@export var extractor_scene: PackedScene
@export var smelter_scene: PackedScene
@export var constructor_scene: PackedScene
@export var storage_scene: PackedScene
var direction = 0
var bitmap: BitMap = BitMap.new()
var bitmap_height = 10000
var bitmap_width = 10000 # needs to be even number
var placed = false
var extractor_position = Vector2i(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	bitmap.resize(Vector2i(bitmap_width,bitmap_height))
	$Camera2D.position.x += global.width * 8
	$Camera2D.position.y += global.height * 8


func _process(_delta):
	if global.ingot >= 15 and global.rod >= 10:
		get_tree().paused = true
	$Camera2D/Goal/RodGoal.text = (str(int(global.rod)) + "/10")
	$Camera2D/Goal/IngotGoal.text = (str(int(global.ingot)) + "/15")
	if Input.is_action_just_pressed("Hotbar_1"):
		if global.slot == 1:
			global.slot = 0
		else:
			global.slot = 1
	if Input.is_action_just_pressed("Hotbar_2"):
		if global.slot == 2:
			global.slot = 0
		else:
			global.slot = 2
	if Input.is_action_just_pressed("Hotbar_3"):
		if global.slot == 3:
			global.slot = 0
		else:
			global.slot = 3
	if Input.is_action_just_pressed("Hotbar_4"):
		if global.slot == 4:
			global.slot = 0
		else:
			global.slot = 4
	if Input.is_action_just_pressed("Hotbar_5"):
		if global.slot == 5:
			global.slot = 0
		else:
			global.slot = 5
	if Input.is_action_pressed("Left_click") and global.slot == 1 \
	and not global.buildings_cant_place:
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
		if not bitmap.get_bit(pos.x , pos.y ):
			print(pos)
			var belt = belt_scene.instantiate()
			belt.position = pos*16
			belt.position.x -= 8
			belt.position.y -= 8
			belt.modulate.a = 1
			belt.rotation_degrees = direction
			belt.direction = rotation/90
			belt.set_meta("Belt", direction/90)
			add_sibling(belt)
			belt.clone = 1
			bitmap.set_bit(pos.x, pos.y, true)
	if Input.is_action_pressed("Left_click") and global.slot == 2 \
	and global.extractor_cant_place:
		$"Camera2D/Can't Place".show()
		$Timer.start()
	if Input.is_action_pressed("Left_click") and global.slot == 2 \
	and not global.extractor_cant_place:
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
		if not bitmap.get_bit(pos.x , pos.y ):
			print(pos)
			var extractor = extractor_scene.instantiate()
			extractor.position = pos*16
			extractor.position.x -= 8
			extractor.position.y -= 8
			extractor.modulate.a = 255
			extractor.rotation_degrees = direction
			extractor.direction = rotation/90
			extractor.set_meta("Extractor", direction/90)
			add_sibling(extractor)
			extractor.clone = 1
			bitmap.set_bit(pos.x, pos.y, true)
			global.extractor_placed = true
	if Input.is_action_pressed("Left_click") and global.slot == 3 \
	and not global.buildings_cant_place:
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
		if not bitmap.get_bit(pos.x , pos.y ):
			print(pos)
			var smelter = smelter_scene.instantiate()
			smelter.position = pos*16
			smelter.modulate.a = 1
			smelter.set_meta("Smelter", direction/90)
			add_sibling(smelter)
			smelter.clone = 1
			bitmap.set_bit(pos.x, pos.y, true)
	if Input.is_action_pressed("Left_click") and global.slot == 4 \
	and not global.buildings_cant_place:
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
		if not bitmap.get_bit(pos.x , pos.y ):
			print(pos)
			var constructor = constructor_scene.instantiate()
			constructor.position = pos*16
			constructor.modulate.a = 1
			constructor.set_meta("Constructor", direction/90)
			add_sibling(constructor)
			constructor.clone = 1
			bitmap.set_bit(pos.x, pos.y, true)
	if Input.is_action_pressed("Left_click") and global.slot == 5 \
	and not global.buildings_cant_place:
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
		if not bitmap.get_bit(pos.x , pos.y ):
			print(pos)
			var storage = storage_scene.instantiate()
			storage.position = pos*16
			storage.position.x -= 8
			storage.position.y -= 8
			storage.modulate.a = 1
			storage.set_meta("Storage", direction/90)
			add_sibling(storage)
			storage.clone = 1
			bitmap.set_bit(pos.x, pos.y, true)
	if Input.is_action_pressed("Right_click"):
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
		if bitmap.get_bit(pos.x, pos.y):
			bitmap.set_bit(pos.x, pos.y, false)
	if Input.is_action_just_pressed("Rotate(R)"):
		direction += 90


func _on_timer_timeout():
	$"Camera2D/Can't Place".hide()
