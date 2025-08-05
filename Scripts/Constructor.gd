extends Area2D

@onready var global = get_node("/root/Global")

@export var rod_scene: PackedScene
@export var copper_wire_scene: PackedScene
var clone = 0
var direction = 0
var delete = 0
var pos = Vector2i(0,0)
var bitmap: BitMap = BitMap.new()

func _ready():
	var map = get_tree().current_scene.get_node("Generated_map")
	var cell = map.local_to_map(position/2)
	var data = map.get_cell_tile_data(cell)
	if not data.get_custom_data("World") == "Unplaceable":
		show()
	else:
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if clone == 0 and global.slot == 4:
		position = get_global_mouse_position().snapped(Vector2(16,16))
	if Input.is_action_pressed("Right_click") and clone and delete == 1:
		var pos = Vector2i(position.snapped(Vector2(16,16))/16)
		global.bitmap.set_bit(pos.x, pos.y, false)
		global.bitmap.set_bit(pos.x+1, pos.y, false)
		global.bitmap.set_bit(pos.x, pos.y+1, false)
		global.bitmap.set_bit(pos.x+1, pos.y+1, false)
		queue_free()
	if clone == 0:
		if global.slot == 4:
			show()
		else:
			hide()

func _on_area_entered(area):
	if clone == 1:
		if area.has_meta("Ingot") and $Rod.visible == true \
		and not $RayCast2D.get_collider():
			var rod = rod_scene.instantiate()
			rod.position = position
			rod.modulate.a = 1
			rod.rotation = rotation
			rod.direction = rotation/90
			rod.set_meta("Rod", direction/90)
			add_sibling.call_deferred(rod)
			rod.clone = 1
		if area.has_meta("Copper_ingot") and $Copper_wire.visible == true \
		and not $RayCast2D.get_collider():
			var copper_wire = copper_wire_scene.instantiate()
			copper_wire.position = position
			copper_wire.modulate.a = 1
			copper_wire.rotation = rotation
			copper_wire.direction = rotation/90
			copper_wire.set_meta("Rod", direction/90)
			add_sibling.call_deferred(copper_wire)
			copper_wire.clone = 1

func _on_mouse_entered():
	delete = 1


func _on_mouse_exited():
	delete = 0


func _on_recipe_selected():
	if clone == 1 and $Recipe.visible == true:
		$Recipe.hide()
		$Recipe_list.show()


func _on_body_entered(_body):
	if clone == 0:
		var map = get_tree().current_scene.get_node("Generated_map")
		var cell = map.local_to_map(position/2)
		var data = map.get_cell_tile_data(cell)
		print(data.get_custom_data("World"))
		if not data.get_custom_data("World") == "Unplaceable":
			global.buildings_cant_place = false
		else:
			global.buildings_cant_place = true


func _on_iron_rod_pressed():
	$Rod.show()
	$Recipe_list.hide()

func _on_copper_wire_pressed():
	$Copper_wire.show()
	$Recipe_list.hide()
