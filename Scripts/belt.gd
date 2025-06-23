extends Area2D


var mouse = true
var clone = 0
var direction = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_meta("Direction"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if mouse == true:
		position = get_global_mouse_position().snapped(Vector2(50,50))
	if Input.is_action_just_pressed("Rotate(R)") and not clone:
		rotation_degrees += 90
	if Input.is_action_pressed("right_click") and clone and \
	position == get_global_mouse_position().snapped(Vector2(50,50)):
		queue_free()


func _on_area_entered(area):
	print("area")
	if clone == 1 and area.has_meta("Direction") and area.get_meta("Direction") >=0 and not \
	area.get_meta("Direction")%4 == get_meta("Direction")%4:
		set_meta("Direction", area.get_meta("Direction"))
		rotation_degrees = 90*area.get_meta("Direction")
		print("attampt")
		print(get_meta("Direction"), "o")
		print(get_meta("Direction"), "f")
