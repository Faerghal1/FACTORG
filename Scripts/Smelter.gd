extends Area2D

@onready var global = get_node("/root/Global")

@export var ingot_scene: PackedScene
var clone = 0
var direction = 0
var delete = 0
var pos = Vector2i(0,0)
var bitmap: BitMap = BitMap.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if clone == 0 and global.slot == 3:
		position = get_global_mouse_position().snapped(Vector2(16,16))
	if Input.is_action_pressed("Right_click") and clone and delete == 1:
		queue_free()
	if clone == 0:
		if global.slot == 3:
			show()
		else:
			hide()


func _on_area_entered(area):
	if area.has_meta("Direction_resource") and $Ingot.visible == true:
		var ingot = ingot_scene.instantiate()
		ingot.position = position
		ingot.modulate.a = 1
		ingot.rotation = rotation
		ingot.direction = rotation/90
		ingot.set_meta("Direction_ingot", direction/90)
		add_sibling.call_deferred(ingot)
		ingot.clone = 1
		ingot.show()


func _on_mouse_entered():
	delete = 1


func _on_mouse_exited():
	delete = 0


func _on_recipe_selected():
	if clone == 1 and $Recipe.visible == true:
		$Recipe.hide()
		$Ingot.show()
