extends Node2D

@onready var global = get_node("/root/Global")

@export var belt_scene: PackedScene
@export var extractor_scene: PackedScene
@export var refiner_scene: PackedScene
var direction = 0
var bitmap: BitMap = BitMap.new()
var height = 10000
var width = 10000 # needs to be even number
var placed = false
var extractor_position = Vector2i(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	bitmap.resize(Vector2i(width,height))
	$Camera2D.position.x += width*25/3
	$Camera2D.position.y += height*25/3


func _process(_delta):
	if global.mouse_entered_belt == true or Input.is_action_just_pressed("Hotbar_1"):
		global.belt = true
		global.extractor = false
		global.refiner = false
		global.mouse_entered_extractor = false
		global.mouse_entered_refiner = false
		global.slot = 1
	if global.mouse_entered_extractor == true or Input.is_action_just_pressed("Hotbar_2"):
		global.extractor = true
		global.belt = false
		global.refiner = false
		global.mouse_entered_belt = false
		global.mouse_entered_refiner = false
		global.slot = 2
	if global.mouse_entered_refiner == true or Input.is_action_just_pressed("Hotbar_3"):
		global.refiner = true
		global.belt = false
		global.extractor = false
		global.mouse_entered_belt = false
		global.mouse_entered_extractor = false
		global.slot = 3
	if Input.is_action_pressed("Left_click") and global.belt == true:
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
			belt.set_meta("Direction_belt", direction/90)
			add_sibling(belt)
			belt.clone = 1
			bitmap.set_bit(pos.x, pos.y, true)
	if Input.is_action_pressed("Left_click") and global.extractor == true:
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
		if not bitmap.get_bit(pos.x , pos.y ):
			print(pos)
			var extractor = extractor_scene.instantiate()
			extractor.position = pos*16
			extractor.position.x -= 8
			extractor.position.y -= 8
			extractor.modulate.a = 1
			extractor.rotation_degrees = direction
			extractor.direction = rotation/90
			extractor.set_meta("Direction_extractor", direction/90)
			add_sibling(extractor)
			extractor.clone = 1
			bitmap.set_bit(pos.x, pos.y, true)
			global.extractor_placed = true
	if Input.is_action_pressed("Left_click") and global.refiner == true:
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
		if not bitmap.get_bit(pos.x , pos.y ):
			print(pos)
			var refiner = refiner_scene.instantiate()
			refiner.position = pos*16
			refiner.modulate.a = 1
			refiner.rotation_degrees = direction
			refiner.direction = rotation/90
			refiner.set_meta("Direction_refiner", direction/90)
			add_sibling(refiner)
			refiner.clone = 1
			bitmap.set_bit(pos.x, pos.y, true)
	if Input.is_action_pressed("Right_click"):
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
		if bitmap.get_bit(pos.x, pos.y):
			bitmap.set_bit(pos.x, pos.y, false)
	if Input.is_action_just_pressed("Rotate(R)"):
		direction += 90
