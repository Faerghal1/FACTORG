extends Node2D
@export var belt_scene: PackedScene
var direction = 0
var bitmap: BitMap = BitMap.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	bitmap.resize(Vector2i(10000,10000))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("Left_click"):
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(50,50))/50)
		if not bitmap.get_bit(pos.x, pos.y):
			var belt = belt_scene.instantiate()
			belt.mouse = false
			belt.position = pos*50
			belt.modulate.a = 50
			belt.rotation_degrees = direction
			belt.direction = rotation/90
			belt.set_meta("Direction", direction/90)
			add_sibling(belt)
			belt.clone = 1
			bitmap.set_bit(pos.x, pos.y, true)
	if Input.is_action_pressed("right_click"):
		var pos = Vector2i(get_global_mouse_position().snapped(Vector2(50,50))/50)
		if bitmap.get_bit(pos.x, pos.y):
			bitmap.set_bit(pos.x, pos.y, false)
	if Input.is_action_just_pressed("Rotate(R)"):
		direction += 90
