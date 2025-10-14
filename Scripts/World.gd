extends Node2D

@onready var global = get_node("/root/Global")
@onready var camera: Camera2D = $Camera2D
@onready var controls: AnimatedSprite2D = $Camera2D/Controls/AnimatedSprite2D
@onready var index: Control = $Camera2D/Index
@onready var pause_menu: Control = $Camera2D/Pause_menu
@onready var metal_frame_goal: Label = $Camera2D/Goal/GoalText/MetalFrameGoal
@onready var circuit_board_goal: Label = $Camera2D/Goal/GoalText/CircuitBoardGoal
@onready var belt_select: Control = $Camera2D/Belt_select
@onready var extractor_select: Control = $Camera2D/Extractor_select
@onready var smelter_select: Control = $Camera2D/Smelter_select
@onready var constructor_select: Control = $Camera2D/Constructor_select
@onready var storage_select: Control = $Camera2D/Storage_select
@onready var combiner_select: Control = $Camera2D/Combiner_select
@onready var building_cant_place: Control = $"Camera2D/Can't Place Building"
@onready var extractor_cant_place: Control = $"Camera2D/Can't Place Extractor"
@onready var timer: Timer = $Timer
@onready var win_screen: Control = $Camera2D/Win_screen
@onready var time_label: Label = $Camera2D/StopwatchUI/TimeLabel
@onready var time_elasped_label: Label = $Camera2D/Win_screen/WinScreenText/TimeElasped
@onready var best_time_label: Label = $Camera2D/Win_screen/WinScreenText/BestTime
@onready var in_world_clones: Node = $In_World_Clones

@export var belt_scene: PackedScene
@export var extractor_scene: PackedScene
@export var smelter_scene: PackedScene
@export var constructor_scene: PackedScene
@export var storage_scene: PackedScene
@export var combiner_scene: PackedScene
var direction: int = 0
var bitmap_height: int = 10000
var bitmap_width: int = 10000 # needs to be even number
var placed: bool = false
var extractor_position: Vector2i = Vector2i(0,0)
var elapsed_time: float = 0.0
var is_running: bool = false
var best_time = null
var b_minutes: int = 0
var b_seconds: int = 0
var b_milliseconds: int = 0
const SAVE_PATH: String = "user://game_data.json"
const SAVE_SEED : String = "user://game_seed.json"
const TILE_OFFSET: int = 8
const TILE_SIZE: int = 16
const TOP_GOAL_AMOUNT: int = 20
const BOTTOM_GOAL_AMOUNT: int = 25
const QUARTER_ROTATION: int = 90
const NUM_ANIMATION_FRAMES: int = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	global.bitmap.resize(Vector2i(bitmap_width,bitmap_height))
	var tile_size = 8
	camera.position.x += global.width * tile_size
	camera.position.y += global.height * tile_size
	controls.frame = 0
	is_running = true
	update_time_display()


func _process(delta):
	if is_running == true:
		elapsed_time += delta
		update_time_display()
	if Input.is_action_just_pressed("Index"):
		if index.visible == false:
			index.show()
	if Input.is_action_just_pressed("Pause"):
		if index.visible == true:
			index.hide()
		else:
			pause_menu.show()
			get_tree().paused = true
	if global.circuit_board >= BOTTOM_GOAL_AMOUNT and global.metal_frame >= TOP_GOAL_AMOUNT:
		get_tree().paused = true
		is_running = false
		load_game_data()
		if best_time == null:
			print("no best time")
			best_time = elapsed_time
			save_game_data(best_time)
		if elapsed_time < best_time:
			print("new best time")
			best_time = elapsed_time
			save_game_data(best_time)
		b_minutes = int(best_time / 60)
		b_seconds = int(fmod(best_time, 60))
		b_milliseconds = int(fmod(best_time, 1) * 100)
		best_time_label.text = ("Best Time: " \
		+ "%02d:%02d.%02d" % [b_minutes, b_seconds, b_milliseconds])
		win_screen.show()
	metal_frame_goal.text = (str(int(global.metal_frame)) + "/20")
	circuit_board_goal.text = (str(int(global.circuit_board)) + "/25")
	if Input.is_action_just_pressed("Hotbar_1"):
		if global.hotbar_slot == global.slot.NONE:
			global.hotbar_slot = global.slot.BELT
		else:
			global.hotbar_slot = global.slot.NONE
	if Input.is_action_just_pressed("Hotbar_2"):
		if global.hotbar_slot == global.slot.NONE:
			global.hotbar_slot = global.slot.EXTRACTOR
		else:
			global.hotbar_slot = global.slot.NONE
	if Input.is_action_just_pressed("Hotbar_3"):
		if global.hotbar_slot == global.slot.NONE:
			global.hotbar_slot = global.slot.SMELTER
		else:
			global.hotbar_slot = global.slot.NONE
	if Input.is_action_just_pressed("Hotbar_4"):
		if global.hotbar_slot == global.slot.NONE:
			global.hotbar_slot = global.slot.CONSTRUCTOR
		else:
			global.hotbar_slot = global.slot.NONE
	if Input.is_action_just_pressed("Hotbar_5"):
		if global.hotbar_slot == global.slot.NONE:
			global.hotbar_slot = global.slot.STORAGE
		else:
			global.hotbar_slot = global.slot.NONE
	if Input.is_action_just_pressed("Hotbar_6"):
		if global.hotbar_slot == global.slot.NONE:
			global.hotbar_slot = global.slot.COMBINER
		else:
			global.hotbar_slot = global.slot.NONE
	if global.hotbar_slot == global.slot.BELT:
		controls.frame = 2
		belt_select.show()
	if global.hotbar_slot == global.slot.EXTRACTOR:
		controls.frame = 2
		extractor_select.show()
	if global.hotbar_slot == global.slot.SMELTER:
		controls.frame = 1
		smelter_select.show()
	if global.hotbar_slot == global.slot.CONSTRUCTOR:
		controls.frame = 1
		constructor_select.show()
	if global.hotbar_slot == global.slot.STORAGE:
		controls.frame = 2
		storage_select.show()
	if global.hotbar_slot == global.slot.COMBINER:
		controls.frame = 1
		combiner_select.show()
	elif global.hotbar_slot == global.slot.NONE:
		controls.frame = 0
		belt_select.hide()
		extractor_select.hide()
		smelter_select.hide()
		constructor_select.hide()
		storage_select.hide()
		combiner_select.hide()
	if global.mouse_on_hotbar == false:
		if Input.is_action_pressed("Left_click") \
		and (global.hotbar_slot != global.slot.EXTRACTOR \
		and global.hotbar_slot != global.slot.NONE): # Detection for placeable in world
			if global.hotbar_slot == global.slot.BELT or global.hotbar_slot == global.slot.STORAGE:
				if global.buildings_cant_place == true: # Buildings_cant_place
					building_cant_place.show()
					timer.start()
			elif global.hotbar_slot == global.slot.SMELTER \
			or global.hotbar_slot == global.slot.CONSTRUCTOR \
			or global.hotbar_slot == global.slot.COMBINER:
				if global.buildings_large_cant_place == true: # Large_buildings_cant_place
					building_cant_place.show()
					timer.start()
		if Input.is_action_pressed("Left_click") \
		and global.hotbar_slot == global.slot.EXTRACTOR \
		and global.extractor_cant_place == true: # Extractor_cant_place
			extractor_cant_place.show()
			timer.start()
		if Input.is_action_pressed("Left_click") \
		and global.hotbar_slot == global.slot.BELT \
		and not global.buildings_cant_place: # Belt_placement
			var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/TILE_SIZE)
			if not global.bitmap.get_bit(pos.x, pos.y):
				print(pos)
				var belt = belt_scene.instantiate()
				belt.position = (get_global_mouse_position() - Vector2.ONE * 8).snapped(Vector2(16,16))
				belt.position += Vector2.ONE * 8
				belt.modulate.a = 1
				belt.rotation_degrees = direction
				belt.direction = rotation/QUARTER_ROTATION
				belt.set_meta("Belt", direction/QUARTER_ROTATION)
				in_world_clones.add_child(belt)
				belt.clone = true
				global.bitmap.set_bit(pos.x, pos.y, true)
		if Input.is_action_pressed("Left_click") \
		and global.hotbar_slot == global.slot.EXTRACTOR \
		and not global.extractor_cant_place: # Extractor_placement
			var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/TILE_SIZE)
			if not global.bitmap.get_bit(pos.x, pos.y):
				print(pos)
				var extractor = extractor_scene.instantiate()
				extractor.position = (get_global_mouse_position() - Vector2.ONE * 8).snapped(Vector2(16,16))
				extractor.position += Vector2.ONE * 8
				extractor.modulate.a = 1
				extractor.rotation_degrees = direction
				extractor.direction = rotation/QUARTER_ROTATION
				extractor.set_meta("Extractor", direction/QUARTER_ROTATION)
				in_world_clones.add_child(extractor)
				extractor.clone = true
				global.bitmap.set_bit(pos.x, pos.y, true)
				global.extractor_placed = true
		if Input.is_action_pressed("Left_click") \
		and global.hotbar_slot == global.slot.SMELTER \
		and not global.buildings_large_cant_place: # Smelter_placement
			var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
			if not global.bitmap.get_bit(pos.x, pos.y) and not global.bitmap.get_bit(pos.x+1, pos.y) \
			and not global.bitmap.get_bit(pos.x, pos.y+1 ) and not global.bitmap.get_bit(pos.x+1, pos.y+1):
				print(pos)
				var smelter = smelter_scene.instantiate()
				smelter.position = pos * TILE_SIZE
				smelter.modulate.a = 1
				smelter.set_meta("Smelter", direction/QUARTER_ROTATION)
				in_world_clones.add_child(smelter)
				smelter.clone = true
				global.bitmap.set_bit(pos.x, pos.y, true)
				global.bitmap.set_bit(pos.x+1, pos.y, true)
				global.bitmap.set_bit(pos.x, pos.y+1, true)
				global.bitmap.set_bit(pos.x+1, pos.y+1, true)
		if Input.is_action_pressed("Left_click") \
		and global.hotbar_slot == global.slot.CONSTRUCTOR \
		and not global.buildings_large_cant_place: # Constructor_placement
			var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/TILE_SIZE)
			if not global.bitmap.get_bit(pos.x, pos.y) \
			and not global.bitmap.get_bit(pos.x+1, pos.y) \
			and not global.bitmap.get_bit(pos.x, pos.y+1) \
			and not global.bitmap.get_bit(pos.x+1, pos.y+1):
				print(pos)
				var constructor = constructor_scene.instantiate()
				constructor.position = pos * TILE_SIZE
				constructor.modulate.a = 1
				constructor.set_meta("Constructor", direction/QUARTER_ROTATION)
				in_world_clones.add_child(constructor)
				constructor.clone = true
				global.bitmap.set_bit(pos.x, pos.y, true)
				global.bitmap.set_bit(pos.x+1, pos.y, true)
				global.bitmap.set_bit(pos.x, pos.y+1, true)
				global.bitmap.set_bit(pos.x+1, pos.y+1, true)
		if Input.is_action_pressed("Left_click") \
		and global.hotbar_slot == global.slot.STORAGE \
		and not global.buildings_cant_place: # Storage_placement
			var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/TILE_SIZE)
			if not global.bitmap.get_bit(pos.x, pos.y):
				print(pos)
				var storage = storage_scene.instantiate()
				storage.position = (get_global_mouse_position() - Vector2.ONE * 8).snapped(Vector2(16,16))
				storage.position += Vector2.ONE * 8
				storage.modulate.a = 1
				storage.rotation_degrees = direction
				storage.direction = rotation/QUARTER_ROTATION
				storage.set_meta("Storage", direction/QUARTER_ROTATION)
				in_world_clones.add_child(storage)
				storage.clone = true
				global.bitmap.set_bit(pos.x, pos.y, true)
		if Input.is_action_pressed("Left_click") \
		and global.hotbar_slot == global.slot.COMBINER \
		and not global.buildings_large_cant_place: # Combiner_placement
			var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/TILE_SIZE)
			if not global.bitmap.get_bit(pos.x, pos.y) \
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
				combiner.position = (get_global_mouse_position() - Vector2.ONE * 8).snapped(Vector2(16,16))
				combiner.position += Vector2.ONE * 8
				combiner.modulate.a = 1
				combiner.set_meta("Combiner", direction/QUARTER_ROTATION)
				in_world_clones.add_child(combiner)
				combiner.clone = true
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
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/TILE_SIZE)
		if global.bitmap.get_bit(pos.x, pos.y):
			global.bitmap.set_bit(pos.x, pos.y, false)
	if Input.is_action_just_pressed("Rotate(R)"):
		direction += QUARTER_ROTATION


func _on_timer_timeout():
	extractor_cant_place.hide()
	building_cant_place.hide()


func _on_hotbar_mouse_entered():
	global.mouse_on_hotbar = true


func _on_hotbar_mouse_exited():
	global.mouse_on_hotbar = false


func _on_resume_pressed():
	pause_menu.hide()
	get_tree().paused = false


func _on_belt_timer_timeout() -> void: # Animates the conveyer belt
	if global.frames < NUM_ANIMATION_FRAMES:
		global.frames += 1
	else:
		global.frames = 0


func update_time_display():
	var minutes = int(elapsed_time / 60)
	var seconds = int(fmod(elapsed_time, 60))
	var milliseconds = int(fmod(elapsed_time, 1) * 100)
	time_label.text = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
	time_elasped_label.text = ("Time Elasped: " \
	+ "%02d:%02d.%02d" % [minutes, seconds, milliseconds])


func save_game_data(best_time: float):
	var save_data = {
		"best_time": best_time
	}
	
	var json_string = JSON.stringify(save_data)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
	else:
		print("Error opening file to save data")


func load_game_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			var parse_result = JSON.parse_string(json_string)
			if parse_result is Dictionary:
				var loaded_data = parse_result
				best_time = loaded_data.get("best_time", null)
				return loaded_data
			else:
				print("Error parsing JSON data")
		else:
			print("Error opening file to load data")
	else:
		print("Save file does not exist")
	return {}


func save_seed(Seed: int):
	var save_data = {
		"Seed": Seed
	}
	var json_string = JSON.stringify(save_data)
	var file = FileAccess.open(SAVE_SEED, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
	else:
		print("Error opening file to save data")


func load_seed():
	if FileAccess.file_exists(SAVE_SEED):
		var file = FileAccess.open(SAVE_SEED, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			var parse_result = JSON.parse_string(json_string)
			if parse_result is Dictionary:
				var loaded_data = parse_result
				global.seed = loaded_data.get("Seed", 0)
				return loaded_data
			else:
				print("Error parsing JSON data")
		else:
			print("Error opening file to load seed")
	else:
		print("Save file does not exist")
	return {}


func _on_save_button_pressed() -> void:
	save_seed(global.seed)


func _on_new_save_button_button_up() -> void:
	global.seed += 1
	get_tree().change_scene_to_packed(load("res://Scenes/Loading_screen.tscn"))


func _on_quit_button_pressed() -> void:
	get_tree().quit()
