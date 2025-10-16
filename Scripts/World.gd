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
var bitmap_height: int = 10000 # Needs to be an even number
var bitmap_width: int = 10000 # Needs to be an even number
var placed: bool = false
var extractor_position: Vector2i = Vector2i(0,0)
var elapsed_time: float = 0.0
var is_running: bool = false
var best_time = null
var b_minutes: int = 0
var b_seconds: int = 0
var b_milliseconds: int = 0
# Numerical list of all control frames starting from 0 ending at 2
enum control_frames {
	DEFAULT_FRAME,
	CANT_ROTATE_FRAME,
	CAN_ROTATE_FRAME,
}
const SAVE_PATH: String = "user://game_data.json"
const SAVE_SEED : String = "user://game_seed.json"
const TILE_OFFSET: int = 8
const TILE_SIZE: int = 16
const TOP_GOAL_AMOUNT: int = 20
const BOTTOM_GOAL_AMOUNT: int = 25
const QUARTER_ROTATION: int = 90
const NUM_ANIMATION_FRAMES: int = 10
const MINUTES_FACTOR: int = 60
const MILLISECONDS_FACTOR: int = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	global.bitmap.resize(Vector2i(bitmap_width,bitmap_height))
	camera.position.x += global.width * TILE_OFFSET
	camera.position.y += global.height * TILE_OFFSET
	controls.frame = control_frames.DEFAULT_FRAME
	is_running = true
	update_time_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	metal_frame_goal.text = (str(int(global.metal_frame)) + "/20")
	circuit_board_goal.text = (str(int(global.circuit_board)) + "/25")
	# If the stopwatch is running it increases elapsed_time and updates the display
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
	# Checks to see if the user has delivered the required components for completion
	if global.circuit_board >= BOTTOM_GOAL_AMOUNT and global.metal_frame >= TOP_GOAL_AMOUNT:
		get_tree().paused = true
		is_running = false
		load_game_data()
		# Checks to see if no best_time is set and sets best_time to the elapsed_time
		if best_time == null:
			print("no best time")
			best_time = elapsed_time
			save_game_data(best_time)
		# Checks to see if elapsed_time is lower than best_time and sets best_time to elasped_time
		if elapsed_time < best_time:
			print("new best time")
			best_time = elapsed_time
			save_game_data(best_time)
		# Updates the best_time label seen in the Win_screen
		b_minutes = int(best_time / MINUTES_FACTOR)
		b_seconds = int(fmod(best_time, MINUTES_FACTOR))
		b_milliseconds = int(fmod(best_time, 1) * MILLISECONDS_FACTOR)
		best_time_label.text = ("Best Time: " \
		+ "%02d:%02d.%02d" % [b_minutes, b_seconds, b_milliseconds])
		win_screen.show()
	# Checks to see if the user has inputted the 1 key and will select or deselect the Belt
	if Input.is_action_just_pressed("Hotbar_1"):
		if global.hotbar_slot == global.slot.NONE:
			global.hotbar_slot = global.slot.BELT
		else:
			global.hotbar_slot = global.slot.NONE
	# Checks to see if the user has inputted the 2 key and will select or deselect the Extractor
	if Input.is_action_just_pressed("Hotbar_2"):
		if global.hotbar_slot == global.slot.NONE:
			global.hotbar_slot = global.slot.EXTRACTOR
		else:
			global.hotbar_slot = global.slot.NONE
	# Checks to see if the user has inputted the 3 key and will select or deselect the Smelter
	if Input.is_action_just_pressed("Hotbar_3"):
		if global.hotbar_slot == global.slot.NONE:
			global.hotbar_slot = global.slot.SMELTER
		else:
			global.hotbar_slot = global.slot.NONE
	# Checks to see if the user has inputted the 4 key and will select or deselect the Constructor
	if Input.is_action_just_pressed("Hotbar_4"):
		if global.hotbar_slot == global.slot.NONE:
			global.hotbar_slot = global.slot.CONSTRUCTOR
		else:
			global.hotbar_slot = global.slot.NONE
	# Checks to see if the user has inputted the 5 key and will select or deselect the Storage
	if Input.is_action_just_pressed("Hotbar_5"):
		if global.hotbar_slot == global.slot.NONE:
			global.hotbar_slot = global.slot.STORAGE
		else:
			global.hotbar_slot = global.slot.NONE
	# Checks to see if the user has inputted the 6 key and will select or deselect the Combiner
	if Input.is_action_just_pressed("Hotbar_6"):
		if global.hotbar_slot == global.slot.NONE:
			global.hotbar_slot = global.slot.COMBINER
		else:
			global.hotbar_slot = global.slot.NONE
	# Checks if global.hotbar_slot = 1 and updates the UI to the Belt UI
	if global.hotbar_slot == global.slot.BELT:
		controls.frame = control_frames.CAN_ROTATE_FRAME
		belt_select.show()
	# Checks if global.hotbar_slot = 2 and updates the UI to the Extractor UI
	if global.hotbar_slot == global.slot.EXTRACTOR:
		controls.frame = control_frames.CAN_ROTATE_FRAME
		extractor_select.show()
	# Checks if global.hotbar_slot = 3 and updates the UI to the Smelter UI
	if global.hotbar_slot == global.slot.SMELTER:
		controls.frame = control_frames.CANT_ROTATE_FRAME
		smelter_select.show()
	# Checks if global.hotbar_slot = 4 and updates the UI to the Constructor UI
	if global.hotbar_slot == global.slot.CONSTRUCTOR:
		controls.frame = control_frames.CANT_ROTATE_FRAME
		constructor_select.show()
	# Checks if global.hotbar_slot = 5 and updates the UI to the Storage UI
	if global.hotbar_slot == global.slot.STORAGE:
		controls.frame = control_frames.CAN_ROTATE_FRAME
		storage_select.show()
	# Checks if global.hotbar_slot = 6 and updates the UI to the Combiner UI
	if global.hotbar_slot == global.slot.COMBINER:
		controls.frame = control_frames.CANT_ROTATE_FRAME
		combiner_select.show()
	# Runs if global.hotbar_slot doesn't equal 1-6 and checks it equals 0
	elif global.hotbar_slot == global.slot.NONE:
		controls.frame = control_frames.DEFAULT_FRAME
		belt_select.hide()
		extractor_select.hide()
		smelter_select.hide()
		constructor_select.hide()
		storage_select.hide()
		combiner_select.hide()
	# Checks to see if the user is trying to place a building while not hovering over the hotbar
	if global.mouse_on_hotbar == false:
		# Checks to see if the user has tried to place a building that isn't the Extractor or null
		if ( 
				Input.is_action_pressed("Left_click")
				and (global.hotbar_slot != global.slot.EXTRACTOR
				and global.hotbar_slot != global.slot.NONE)
		):
			# Checks to see if the users has selected any 1x1 building except Extractor
			if (
					global.hotbar_slot == global.slot.BELT 
					or global.hotbar_slot == global.slot.STORAGE
			):
				# Checks to see if 1x1 buildings can't be placed in world except Extractor
				if global.buildings_cant_place == true:
					building_cant_place.show()
					timer.start()
			# Checks to see if the users has selected any non 1x1 building
			elif (
					global.hotbar_slot == global.slot.SMELTER \
					or global.hotbar_slot == global.slot.CONSTRUCTOR \
					or global.hotbar_slot == global.slot.COMBINER
			):
				# Checks to see if non 1x1 buildings can't be placed in world
				if global.buildings_large_cant_place == true:
					building_cant_place.show()
					timer.start()
		# Checks to see if the Extractor can't be placed in world
		if (
				Input.is_action_pressed("Left_click")
				and global.hotbar_slot == global.slot.EXTRACTOR
				and global.extractor_cant_place == true
		):
			extractor_cant_place.show()
			timer.start()
		# Checks to see if the user has selected the Belt and it can be placed in world
		if (
				Input.is_action_pressed("Left_click")
				and global.hotbar_slot == global.slot.BELT
				and not global.buildings_cant_place
		):
			var pos: Vector2i = Vector2i((get_global_mouse_position() \
				- Vector2.ONE * TILE_OFFSET).snapped(Vector2(16,16)) / TILE_SIZE)
			# Creates an instansiated clone of the Belt and sets the bitmap
			if not global.bitmap.get_bit(pos.x, pos.y):
				print(pos)
				var belt: Node = belt_scene.instantiate()
				belt.position = (get_global_mouse_position() \
				- Vector2.ONE * TILE_OFFSET).snapped(Vector2(16,16))
				belt.position += Vector2.ONE * TILE_OFFSET
				belt.modulate.a = 1
				belt.rotation_degrees = direction
				belt.direction = rotation / QUARTER_ROTATION
				belt.set_meta("Belt", direction / QUARTER_ROTATION)
				in_world_clones.add_child(belt)
				belt.clone = true
				belt.hide()
				if global.successful_place == true:
					belt.show()
				global.bitmap.set_bit(pos.x, pos.y, true)
		# Checks to see if the user has selected the Extractor and it can be placed in world
		if (
				Input.is_action_pressed("Left_click")
				and global.hotbar_slot == global.slot.EXTRACTOR
				and not global.extractor_cant_place
		):
			var pos: Vector2i =  Vector2i((get_global_mouse_position() \
				- Vector2.ONE * TILE_OFFSET).snapped(Vector2(16,16)) / TILE_SIZE)
			# Creates an instansiated clone of the Extractor and sets the bitmap
			if not global.bitmap.get_bit(pos.x, pos.y):
				print(pos)
				var extractor: Node = extractor_scene.instantiate()
				extractor.position = (get_global_mouse_position() \
				- Vector2.ONE * TILE_OFFSET).snapped(Vector2(16,16))
				extractor.position += Vector2.ONE * TILE_OFFSET
				extractor.modulate.a = 1
				extractor.rotation_degrees = direction
				extractor.direction = rotation / QUARTER_ROTATION
				extractor.set_meta("Extractor", direction / QUARTER_ROTATION)
				in_world_clones.add_child(extractor)
				extractor.clone = true
				extractor.hide()
				if global.successful_place == true:
					extractor.show()
				global.bitmap.set_bit(pos.x, pos.y, true)
				global.extractor_placed = true
		# Checks to see if the user has selected the Smelter and it can be placed in world
		if (
				Input.is_action_pressed("Left_click")
				and global.hotbar_slot == global.slot.SMELTER
				and not global.buildings_large_cant_place
		):
			var pos: Vector2i = Vector2i(get_global_mouse_position().snapped(Vector2(16,16)) / TILE_SIZE)
			# Creates an instansiated clone of the Smelter and sets the bitmap
			print(pos)
			var smelter: Node = smelter_scene.instantiate()
			smelter.position = pos * TILE_SIZE
			smelter.modulate.a = 1
			smelter.set_meta("Smelter", direction / QUARTER_ROTATION)
			in_world_clones.add_child(smelter)
			smelter.clone = true
			smelter.hide()
			if global.successful_place == true:
				smelter.show()
			if (
					not global.bitmap.get_bit(((smelter.position.x - TILE_OFFSET) 
				/ TILE_SIZE), ((smelter.position.y - TILE_OFFSET) / TILE_SIZE)) 
					and not global.bitmap.get_bit(((smelter.position.x - TILE_OFFSET) 
				/ TILE_SIZE), ((smelter.position.y + TILE_OFFSET) / TILE_SIZE))
					and not global.bitmap.get_bit(((smelter.position.x + TILE_OFFSET) 
				/ TILE_SIZE), ((smelter.position.y - TILE_OFFSET) / TILE_SIZE)) 
					and not global.bitmap.get_bit(((smelter.position.x + TILE_OFFSET) 
				/ TILE_SIZE), ((smelter.position.y + TILE_OFFSET) / TILE_SIZE))
			):
				global.bitmap.set_bit(((smelter.position.x - TILE_OFFSET) 
				/ TILE_SIZE), ((smelter.position.y - TILE_OFFSET) / TILE_SIZE), true)
				global.bitmap.set_bit(((smelter.position.x + TILE_OFFSET) 
				/ TILE_SIZE), ((smelter.position.y - TILE_OFFSET) / TILE_SIZE), true)
				global.bitmap.set_bit(((smelter.position.x - TILE_OFFSET) 
				/ TILE_SIZE), ((smelter.position.y + TILE_OFFSET) / TILE_SIZE), true)
				global.bitmap.set_bit(((smelter.position.x + TILE_OFFSET) 
				/ TILE_SIZE), ((smelter.position.y + TILE_OFFSET) / TILE_SIZE), true)
			else:
				smelter.queue_free()
		# Checks to see if the user has selected the Constructor and it can be placed in world
		if (
				Input.is_action_pressed("Left_click") \
				and global.hotbar_slot == global.slot.CONSTRUCTOR \
				and not global.buildings_large_cant_place
		):
			var pos: Vector2i = Vector2i(get_global_mouse_position().snapped(Vector2(16,16)) / TILE_SIZE)
			# Creates an instansiated clone of the Constructor and sets the bitmap
			print(pos)
			var constructor: Node = constructor_scene.instantiate()
			constructor.position = pos * TILE_SIZE
			constructor.modulate.a = 1
			constructor.set_meta("Constructor", direction / QUARTER_ROTATION)
			in_world_clones.add_child(constructor)
			constructor.clone = true
			constructor.hide()
			if global.successful_place == true:
				constructor.show()
			if (
					not global.bitmap.get_bit(((constructor.position.x - TILE_OFFSET) 
				/ TILE_SIZE), ((constructor.position.y - TILE_OFFSET) / TILE_SIZE)) 
					and not global.bitmap.get_bit(((constructor.position.x - TILE_OFFSET) 
				/ TILE_SIZE), ((constructor.position.y + TILE_OFFSET) / TILE_SIZE))
					and not global.bitmap.get_bit(((constructor.position.x + TILE_OFFSET) 
				/ TILE_SIZE), ((constructor.position.y - TILE_OFFSET) / TILE_SIZE)) 
					and not global.bitmap.get_bit(((constructor.position.x + TILE_OFFSET) 
				/ TILE_SIZE), ((constructor.position.y + TILE_OFFSET) / TILE_SIZE))
			):
				global.bitmap.set_bit(((constructor.position.x - TILE_OFFSET) 
				/ TILE_SIZE), ((constructor.position.y - TILE_OFFSET) / TILE_SIZE), true)
				global.bitmap.set_bit(((constructor.position.x + TILE_OFFSET) 
				/ TILE_SIZE), ((constructor.position.y - TILE_OFFSET) / TILE_SIZE), true)
				global.bitmap.set_bit(((constructor.position.x - TILE_OFFSET) 
				/ TILE_SIZE), ((constructor.position.y + TILE_OFFSET) / TILE_SIZE), true)
				global.bitmap.set_bit(((constructor.position.x + TILE_OFFSET) 
				/ TILE_SIZE), ((constructor.position.y + TILE_OFFSET) / TILE_SIZE), true)
			else:
				constructor.queue_free()
		# Checks to see if the user has selected the Storage and it can be placed in world
		if (
				Input.is_action_pressed("Left_click") \
				and global.hotbar_slot == global.slot.STORAGE \
				and not global.buildings_cant_place
		):
			var pos: Vector2i =  Vector2i((get_global_mouse_position() \
				- Vector2.ONE * TILE_OFFSET).snapped(Vector2(16,16)) / TILE_SIZE)
			# Creates an instansiated clone of the Storage and sets the bitmap
			if not global.bitmap.get_bit(pos.x, pos.y):
				print(pos)
				var storage: Node = storage_scene.instantiate()
				storage.position = (get_global_mouse_position() \
				- Vector2.ONE * TILE_OFFSET).snapped(Vector2(16,16))
				storage.position += Vector2.ONE * TILE_OFFSET
				storage.modulate.a = 1
				storage.rotation_degrees = direction
				storage.direction = rotation / QUARTER_ROTATION
				storage.set_meta("Storage", direction / QUARTER_ROTATION)
				in_world_clones.add_child(storage)
				storage.clone = true
				storage.hide()
				if global.successful_place == true:
					storage.show()
				global.bitmap.set_bit(pos.x, pos.y, true)
		# Checks to see if the user has selected the Combiner and it can be placed in world
		if (
				Input.is_action_pressed("Left_click")
				and global.hotbar_slot == global.slot.COMBINER
				and not global.buildings_large_cant_place
		):
			var pos: Vector2i = Vector2i((get_global_mouse_position() \
				- Vector2.ONE * TILE_OFFSET).snapped(Vector2(16,16)) / TILE_SIZE)
			# Creates an instansiated clone of the Combiner and sets the bitmap
			if (
					not global.bitmap.get_bit(pos.x, pos.y)
					and not global.bitmap.get_bit(pos.x + 1, pos.y)
					and not global.bitmap.get_bit(pos.x, pos.y + 1) 
					and not global.bitmap.get_bit(pos.x + 1, pos.y + 1)
					and not global.bitmap.get_bit(pos.x - 1, pos.y)
					and not global.bitmap.get_bit(pos.x - 1, pos.y + 1)
					and not global.bitmap.get_bit(pos.x - 1, pos.y - 1)
					and not global.bitmap.get_bit(pos.x, pos.y - 1)
					and not global.bitmap.get_bit(pos.x + 1, pos.y - 1)
			):
				print(pos)
				var combiner: Node = combiner_scene.instantiate()
				combiner.position = (get_global_mouse_position() \
				 - Vector2.ONE * TILE_OFFSET).snapped(Vector2(16,16))
				combiner.position += Vector2.ONE * TILE_OFFSET
				combiner.modulate.a = 1
				combiner.set_meta("Combiner", direction / QUARTER_ROTATION)
				in_world_clones.add_child(combiner)
				combiner.clone = true
				combiner.hide()
				if global.successful_place == true:
					combiner.show()
				global.bitmap.set_bit(pos.x, pos.y, true)
				global.bitmap.set_bit(pos.x+1, pos.y, true)
				global.bitmap.set_bit(pos.x, pos.y+1, true)
				global.bitmap.set_bit(pos.x + 1, pos.y + 1, true)
				global.bitmap.set_bit(pos.x - 1, pos.y, true)
				global.bitmap.set_bit(pos.x - 1, pos.y + 1, true)
				global.bitmap.set_bit(pos.x - 1, pos.y - 1, true)
				global.bitmap.set_bit(pos.x, pos.y - 1, true)
				global.bitmap.set_bit(pos.x + 1, pos.y - 1, true)
	# This deletes the placeable machinery and sets the deletes the bitmap
	if Input.is_action_pressed("Right_click"):
		var pos: Vector2i = Vector2i(get_global_mouse_position().snapped(Vector2(16,16)) / TILE_SIZE)
		if global.bitmap.get_bit(pos.x, pos.y):
			global.bitmap.set_bit(pos.x, pos.y, false)
	# This controls the rotation of the placeable machinery
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


# This updates the animations for the placeable objects in world
func _on_placeable_animations_timer_timeout() -> void: # Animates the conveyer belt
	if global.frames < NUM_ANIMATION_FRAMES:
		global.frames += 1
	else:
		global.frames = 0


# This updates the stopwatch seen in the top center of the World scene
func update_time_display():
	var minutes: int = int(elapsed_time / MINUTES_FACTOR)
	var seconds: int = int(fmod(elapsed_time, MINUTES_FACTOR))
	var milliseconds: int = int(fmod(elapsed_time, 1) * MILLISECONDS_FACTOR)
	time_label.text = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
	time_elasped_label.text = ("Time Elasped: " \
	+ "%02d:%02d.%02d" % [minutes, seconds, milliseconds])


# This saves best_time to the file containing the users best_time
func save_game_data(best_time: float):
	var save_data: Dictionary = {
		"best_time": best_time
	}
	
	var json_string: String = JSON.stringify(save_data)
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
	else:
		print("Error opening file to save data")


# This access the file which contains the users best time and sets best_time
func load_game_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var json_string: String = file.get_as_text()
			file.close()
			var parse_result: Dictionary = JSON.parse_string(json_string)
			if parse_result is Dictionary:
				var loaded_data: Dictionary = parse_result
				best_time = loaded_data.get("best_time", null)
				return loaded_data
			else:
				print("Error parsing JSON data")
		else:
			print("Error opening file to load data")
	else:
		print("Save file does not exist")
	return {}


# This saves the map seed to the file which contains the map seed
func save_seed(Seed: int):
	var save_data: Dictionary = {
		"Seed": Seed
	}
	var json_string: String = JSON.stringify(save_data)
	var file: FileAccess = FileAccess.open(SAVE_SEED, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
	else:
		print("Error opening file to save data")


# This access the file which contains the map seed and sets the seed to the saved seed
func load_seed():
	if FileAccess.file_exists(SAVE_SEED):
		var file: FileAccess = FileAccess.open(SAVE_SEED, FileAccess.READ)
		if file:
			var json_string: String = file.get_as_text()
			file.close()
			var parse_result: Dictionary = JSON.parse_string(json_string)
			if parse_result is Dictionary:
				var loaded_data: Dictionary = parse_result
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


func _on_new_seed_button_pressed() -> void:
	global.seed += 1
	get_tree().change_scene_to_packed(load("res://Scenes/Loading_screen.tscn"))


func _on_quit_button_pressed() -> void:
	get_tree().quit()
