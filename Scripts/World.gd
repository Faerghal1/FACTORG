extends Node2D

@onready var global = get_node("/root/Global")

@export var belt_scene: PackedScene
@export var extractor_scene: PackedScene
@export var smelter_scene: PackedScene
@export var constructor_scene: PackedScene
@export var storage_scene: PackedScene
var direction = 0
var bitmap_height = 10000
var bitmap_width = 10000 # needs to be even number
var placed = false
var extractor_position = Vector2i(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	global.bitmap.resize(Vector2i(bitmap_width,bitmap_height))
	$Camera2D.position.x += global.width * 8
	$Camera2D.position.y += global.height * 8
	$Camera2D/Controls/AnimatedSprite2D.frame = 0


func _process(_delta):
	if Input.is_action_just_pressed("Index"):
		if $Camera2D/Index.visible == false:
			$Camera2D/Index.show()
		elif $Camera2D/Index.visible == true:
			$Camera2D/Index.hide()
	if Input.is_action_just_pressed("Pause"):
		$Camera2D/Pause_temp.show()
		get_tree().paused = true
	if global.copper_wire >= 15 and global.rod >= 10:
		get_tree().paused = true
	$Camera2D/Goal/RodGoal.text = (str(int(global.rod)) + "/10")
	$Camera2D/Goal/WireGoal.text = (str(int(global.copper_wire)) + "/15")
	if Input.is_action_just_pressed("Hotbar_1"): # Belt
		if global.slot == 1:
			$Camera2D/Controls/AnimatedSprite2D.frame = 0
			$Camera2D/Belt_select.hide()
			global.slot = 0
		else:
			global.slot = 1
			$Camera2D/Controls/AnimatedSprite2D.frame = 2
			$Camera2D/Belt_select.show()
	if Input.is_action_just_pressed("Hotbar_2"): # Extractor
		if global.slot == 2:
			$Camera2D/Controls/AnimatedSprite2D.frame = 0
			$Camera2D/Extractor_select.hide()
			global.slot = 0
		else:
			global.slot = 2
			$Camera2D/Controls/AnimatedSprite2D.frame = 2
			$Camera2D/Extractor_select.show()
	if Input.is_action_just_pressed("Hotbar_3"): # Smelter
		if global.slot == 3:
			$Camera2D/Controls/AnimatedSprite2D.frame = 0
			$Camera2D/Smelter_select.hide()
			global.slot = 0
		else:
			global.slot = 3
			$Camera2D/Controls/AnimatedSprite2D.frame = 1
			$Camera2D/Smelter_select.show()
	if Input.is_action_just_pressed("Hotbar_4"): # Constructor
		if global.slot == 4:
			$Camera2D/Controls/AnimatedSprite2D.frame = 0
			$Camera2D/Constructor_select.hide()
			global.slot = 0
		else:
			global.slot = 4
			$Camera2D/Controls/AnimatedSprite2D.frame = 1
			$Camera2D/Constructor_select.show()
	if Input.is_action_just_pressed("Hotbar_5"): # Storage
		if global.slot == 5:
			$Camera2D/Controls/AnimatedSprite2D.frame = 0
			$Camera2D/Storage_select.hide()
			global.slot = 0
		else:
			global.slot = 5
			$Camera2D/Controls/AnimatedSprite2D.frame = 2
			$Camera2D/Storage_select.show()
	if not global.slot == 1: # Belt_tooltip
		$Camera2D/Belt_select.hide()
	if not global.slot == 2: # Extractor_tooltip
		$Camera2D/Extractor_select.hide()
	if not global.slot == 3: # Smelter_tooltip
		$Camera2D/Smelter_select.hide()
	if not global.slot == 4: # Constructor_tooltip
		$Camera2D/Constructor_select.hide()
	if not global.slot == 5: # Storage_tooltip
		$Camera2D/Storage_select.hide()
	if global.mouse_on_hotbar == false:
		if Input.is_action_pressed("Left_click") \
		and (global.slot != 2 and global.slot != 0): # Detection for placeable in world
			if global.slot == 1 or global.slot == 5:
				if global.buildings_cant_place == true: # Buildings_cant_place
					$"Camera2D/Can't Place Building".show()
					$Timer.start()
			elif global.slot == 3 or global.slot == 4:
				if global.buildings_large_cant_place == true: # Large_buildings_cant_place
					$"Camera2D/Can't Place Building".show()
					$Timer.start()
		if Input.is_action_pressed("Left_click") and global.slot == 2 \
		and global.extractor_cant_place == true: # Extractor_cant_place
			$"Camera2D/Can't Place Extractor".show()
			$Timer.start()
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
	if Input.is_action_pressed("Right_click"):
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
		if global.bitmap.get_bit(pos.x, pos.y):
			global.bitmap.set_bit(pos.x, pos.y, false)
	if Input.is_action_just_pressed("Rotate(R)"):
		direction += 90


func _on_timer_timeout():
	$"Camera2D/Can't Place Extractor".hide()
	$"Camera2D/Can't Place Building".hide()


func _on_hotbar_mouse_entered():
	global.mouse_on_hotbar = true


func _on_hotbar_mouse_exited():
	global.mouse_on_hotbar = false


func _on_main_menu_pressed():
	get_tree().quit()


func _on_resume_pressed():
	$Camera2D/Pause_temp.hide()
	get_tree().paused = false
