extends Node2D

@onready var global = get_node("/root/Global")

@export var belt_scene: PackedScene
@export var extractor_scene: PackedScene
@export var resource_scene: PackedScene
var direction = 0
var bitmap: BitMap = BitMap.new()
var height = 10000
var width = 10000# needs to be even number
var placed = false
var extractor_placed = false
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
		global.mouse_entered_extractor = false
	if global.mouse_entered_extractor == true or Input.is_action_just_pressed("Hotbar_2"):
		global.extractor = true
		global.belt = false
		global.mouse_entered_belt = false
	if Input.is_action_pressed("Left_click") and global.belt == true:
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
		if not bitmap.get_bit(pos.x , pos.y ):
			print(pos)
			var belt = belt_scene.instantiate()
			belt.position = pos*16
			belt.position.x -= 8
			belt.position.y -= 8
			belt.modulate.a = 50
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
			extractor.modulate.a = 50
			extractor.rotation_degrees = direction
			extractor.direction = rotation/90
			extractor.set_meta("Direction_extractor", direction/90)
			add_sibling(extractor)
			extractor.clone = 1
			bitmap.set_bit(pos.x, pos.y, true)
			extractor_placed = true
	if Input.is_action_pressed("Right_click"):
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
		if bitmap.get_bit(pos.x, pos.y):
			bitmap.set_bit(pos.x, pos.y, false)
	if Input.is_action_just_pressed("Rotate(R)"):
		direction += 90


func _resource():
	if extractor_placed == true:
		var pos = Vector2i(extractor_position)
		if not bitmap.get_bit(pos.x , pos.y ):
			print(pos)
			var resource = resource_scene.instantiate()
			resource.position = pos*16
			resource.position.x -= 8
			resource.position.y -= 8
			resource.modulate.a = 50
			resource.rotation_degrees = direction
			resource.direction = rotation/90
			resource.set_meta("Direction_resource", direction/90)
			add_sibling(resource)
			resource.clone = 1
			bitmap.set_bit(pos.x, pos.y, true)
			print("cloned")
			resource.show()
