extends Node2D

@onready var global = get_node("/root/Global")
@onready var camera = $Camera2D
@onready var controls = $Camera2D/Controls/AnimatedSprite2D
@onready var index = $Camera2D/Index
@onready var pause_menu = $Camera2D/Pause_menu
@onready var rod_goal = $Camera2D/Goal/RodGoal
@onready var circuit_board_goal = $Camera2D/Goal/CircuitBoardGoal
@onready var belt_select = $Camera2D/Belt_select
@onready var extractor_select = $Camera2D/Extractor_select
@onready var smelter_select = $Camera2D/Smelter_select
@onready var constructor_select = $Camera2D/Constructor_select
@onready var storage_select = $Camera2D/Storage_select
@onready var combiner_select = $Camera2D/Combiner_select
@onready var building_cant_place = $"Camera2D/Can't Place Building"
@onready var extractor_cant_place = $"Camera2D/Can't Place Extractor"
@onready var timer = $Timer

@export var belt_scene: PackedScene
@export var extractor_scene: PackedScene
@export var smelter_scene: PackedScene
@export var constructor_scene: PackedScene
@export var storage_scene: PackedScene
@export var combiner_scene: PackedScene
var direction = 0
var bitmap_height = 10000
var bitmap_width = 10000 # needs to be even number
var placed = false
var extractor_position = Vector2i(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	global.bitmap.resize(Vector2i(bitmap_width,bitmap_height))
	camera.position.x += global.width * 8
	camera.position.y += global.height * 8
	controls.frame = 0


func _process(_delta):
	if Input.is_action_just_pressed("Index"):
		if index.visible == false:
			index.show()
	if Input.is_action_just_pressed("Pause"):
		if index.visible == true:
			index.hide()
		else:
			pause_menu.show()
			get_tree().paused = true
	if global.circuit_board >= 25 and global.rod >= 20:
		get_tree().paused = true
	rod_goal.text = (str(int(global.rod)) + "/20")
	circuit_board_goal.text = (str(int(global.circuit_board)) + "/25")
	if Input.is_action_just_pressed("Hotbar_1"): # Belt hotkey selection
		if global.slot == 1:
			controls.frame = 0
			belt_select.hide()
			global.slot = 0
		else:
			global.slot = 1
			controls.frame = 2
			belt_select.show()
	if Input.is_action_just_pressed("Hotbar_2"): # Extractor hotkey selection
		if global.slot == 2:
			controls.frame = 0
			extractor_select.hide()
			global.slot = 0
		else:
			global.slot = 2
			controls.frame = 2
			extractor_select.show()
	if Input.is_action_just_pressed("Hotbar_3"): # Smelter hotkey selection
		if global.slot == 3:
			controls.frame = 0
			smelter_select.hide()
			global.slot = 0
		else:
			global.slot = 3
			controls.frame = 1
			smelter_select.show()
	if Input.is_action_just_pressed("Hotbar_4"): # Constructor hotkey selection
		if global.slot == 4:
			controls.frame = 0
			constructor_select.hide()
			global.slot = 0
		else:
			global.slot = 4
			controls.frame = 1
			constructor_select.show()
	if Input.is_action_just_pressed("Hotbar_5"): # Storage hotkey selection
		if global.slot == 5:
			controls.frame = 0
			storage_select.hide()
			global.slot = 0
		else:
			global.slot = 5
			controls.frame = 2
			storage_select.show()
	if Input.is_action_just_pressed("Hotbar_6"): # Combiner hotkey selection
		if global.slot == 6:
			controls.frame = 0
			combiner_select.hide()
			global.slot = 0
		else:
			global.slot = 6
			controls.frame = 1
			combiner_select.show()
	if global.hotbar_pressed == 1: # Belt hotbar selection
		global.slot = 1
		controls.frame = 2
		belt_select.show()
	if global.hotbar_pressed == 2: # Extractor hotbar selection
		global.slot = 2
		controls.frame = 2
		extractor_select.show()
	if global.hotbar_pressed == 3: # Smelter hotbar selection
		global.slot = 3
		controls.frame = 1
		smelter_select.show()
	if global.hotbar_pressed == 4: # Constructor hotbar selection
		global.slot = 4
		controls.frame = 1
		constructor_select.show()
	if global.hotbar_pressed == 5: # Storage hotbar selection
		global.slot = 5
		controls.frame = 2
		storage_select.show()
	if global.hotbar_pressed == 6: # Combiner hotbar selection
		global.slot = 6
		controls.frame = 1
		combiner_select.show()
	if not global.slot == 1: # Belt_tooltip
		belt_select.hide()
	if not global.slot == 2: # Extractor_tooltip
		extractor_select.hide()
	if not global.slot == 3: # Smelter_tooltip
		smelter_select.hide()
	if not global.slot == 4: # Constructor_tooltip
		constructor_select.hide()
	if not global.slot == 5: # Storage_tooltip
		storage_select.hide()
	if not global.slot == 6: # Combiner_tooltip
		combiner_select.hide()
	if global.mouse_on_hotbar == false:
		if Input.is_action_pressed("Left_click") \
		and (global.slot != 2 and global.slot != 0): # Detection for placeable in world
			if global.slot == 1 or global.slot == 5:
				if global.buildings_cant_place == true: # Buildings_cant_place
					building_cant_place.show()
					timer.start()
			elif global.slot == 3 or global.slot == 4 or global.slot == 6:
				if global.buildings_large_cant_place == true: # Large_buildings_cant_place
					building_cant_place.show()
					timer.start()
		if Input.is_action_pressed("Left_click") and global.slot == 2 \
		and global.extractor_cant_place == true: # Extractor_cant_place
			extractor_cant_place.show()
			timer.start()
		if Input.is_action_pressed("Left_click") and global.slot == 1 \
		and not global.buildings_cant_place: # Belt_placement
			var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
			if not global.bitmap.get_bit(pos.x , pos.y ):
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
				global.bitmap.set_bit(pos.x, pos.y, true)
		if Input.is_action_pressed("Left_click") and global.slot == 2 \
		and not global.extractor_cant_place: # Extractor_placement
			var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
			if not global.bitmap.get_bit(pos.x , pos.y ):
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
				global.bitmap.set_bit(pos.x, pos.y, true)
				global.extractor_placed = true
		if Input.is_action_pressed("Left_click") and global.slot == 3 \
		and not global.buildings_large_cant_place: # Smelter_placement
			var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
			if not global.bitmap.get_bit(pos.x , pos.y ) and not global.bitmap.get_bit(pos.x+1, pos.y) \
			and not global.bitmap.get_bit(pos.x, pos.y+1 ) and not global.bitmap.get_bit(pos.x+1, pos.y+1):
				print(pos)
				var smelter = smelter_scene.instantiate()
				smelter.position = pos*16
				smelter.modulate.a = 1
				smelter.set_meta("Smelter", direction/90)
				add_sibling(smelter)
				smelter.clone = 1
				global.bitmap.set_bit(pos.x, pos.y, true)
				global.bitmap.set_bit(pos.x+1, pos.y, true)
				global.bitmap.set_bit(pos.x, pos.y+1, true)
				global.bitmap.set_bit(pos.x+1, pos.y+1, true)
		if Input.is_action_pressed("Left_click") and global.slot == 4 \
		and not global.buildings_large_cant_place: # Constructor_placement
			var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
			if not global.bitmap.get_bit(pos.x , pos.y ) and not global.bitmap.get_bit(pos.x+1, pos.y) \
			and not global.bitmap.get_bit(pos.x, pos.y+1 ) and not global.bitmap.get_bit(pos.x+1, pos.y+1):
				print(pos)
				var constructor = constructor_scene.instantiate()
				constructor.position = pos*16
				constructor.modulate.a = 1
				constructor.set_meta("Constructor", direction/90)
				add_sibling(constructor)
				constructor.clone = 1
				global.bitmap.set_bit(pos.x, pos.y, true)
				global.bitmap.set_bit(pos.x+1, pos.y, true)
				global.bitmap.set_bit(pos.x, pos.y+1, true)
				global.bitmap.set_bit(pos.x+1, pos.y+1, true)
		if Input.is_action_pressed("Left_click") and global.slot == 5 \
		and not global.buildings_cant_place: # Storage_placement
			var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
			if not global.bitmap.get_bit(pos.x , pos.y ):
				print(pos)
				var storage = storage_scene.instantiate()
				storage.position = pos*16
				storage.position.x -= 8
				storage.position.y -= 8
				storage.modulate.a = 1
				storage.rotation_degrees = direction
				storage.direction = rotation/180
				storage.set_meta("Storage", direction/180)
				add_sibling(storage)
				storage.clone = 1
				global.bitmap.set_bit(pos.x, pos.y, true)
		if Input.is_action_pressed("Left_click") and global.slot == 6 \
		and not global.buildings_large_cant_place: # Combiner_placement
			var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
			if not global.bitmap.get_bit(pos.x , pos.y ) \
			and not global.bitmap.get_bit(pos.x+1, pos.y) \
			and not global.bitmap.get_bit(pos.x, pos.y+1 ) \
			and not global.bitmap.get_bit(pos.x+1, pos.y+1) \
			and not global.bitmap.get_bit(pos.x-1, pos.y) \
			and not global.bitmap.get_bit(pos.x-1, pos.y+1) \
			and not global.bitmap.get_bit(pos.x-1, pos.y-1) \
			and not global.bitmap.get_bit(pos.x, pos.y-1) \
			and not global.bitmap.get_bit(pos.x+1, pos.y-1):
				print(pos)
				var combiner = combiner_scene.instantiate()
				combiner.position = pos*16
				combiner.position.x -= 8
				combiner.position.y -= 8
				combiner.modulate.a = 1
				combiner.set_meta("Combiner", direction/90)
				add_sibling(combiner)
				combiner.clone = 1
				global.bitmap.set_bit(pos.x, pos.y, true)
				global.bitmap.set_bit(pos.x+1, pos.y, true)
				global.bitmap.set_bit(pos.x, pos.y+1, true)
				global.bitmap.set_bit(pos.x+1, pos.y+1, true)
				global.bitmap.set_bit(pos.x-1, pos.y, true)
				global.bitmap.set_bit(pos.x-1, pos.y+1, true)
				global.bitmap.set_bit(pos.x-1, pos.y-1, true)
				global.bitmap.set_bit(pos.x, pos.y-1, true)
				global.bitmap.set_bit(pos.x+1, pos.y-1, true)
	if Input.is_action_pressed("Right_click"):
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
		if global.bitmap.get_bit(pos.x, pos.y):
			global.bitmap.set_bit(pos.x, pos.y, false)
	if Input.is_action_just_pressed("Rotate(R)"):
		direction += 90


func _on_timer_timeout():
	extractor_cant_place.hide()
	building_cant_place.hide()


func _on_hotbar_mouse_entered():
	global.mouse_on_hotbar = true


func _on_hotbar_mouse_exited():
	global.mouse_on_hotbar = false


func _on_main_menu_pressed():
	get_tree().quit()


func _on_resume_pressed():
	pause_menu.hide()
	get_tree().paused = false


func _on_belt_timer_timeout() -> void: # Animates the conveyer belt
	if global.frames < 10:
		global.frames += 1
	else:
		global.frames = 0
