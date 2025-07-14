extends Node2D
@export var belt_scene: PackedScene
var direction = 0
var bitmap: BitMap = BitMap.new()
var height = 10000
var width = 10000# needs to be even number
# Called when the node enters the scene tree for the first time.
func _ready():
	bitmap.resize(Vector2i(width,height))
	$Map_Cam_Scene/Camera.position.x += width*25/3
	$Map_Cam_Scene/Camera.position.y += height*25/3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("Left_click"):
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
		if not bitmap.get_bit(pos.x , pos.y ):
			print(pos)
			var belt = belt_scene.instantiate()
			belt.mouse = false
			belt.position = pos*16
			belt.position.x -= 8
			belt.position.y -= 8
			belt.modulate.a = 50
			belt.rotation_degrees = direction
			belt.direction = rotation/90
			belt.set_meta("Direction", direction/90)
			add_sibling(belt)
			belt.clone = 1
			bitmap.set_bit(pos.x, pos.y, true)
	if Input.is_action_pressed("right_click"):
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(16,16))/16)
		if bitmap.get_bit(pos.x, pos.y):
			bitmap.set_bit(pos.x, pos.y, false)
	if Input.is_action_just_pressed("Rotate(R)"):
		direction += 90
