extends Area2D

@onready var global = get_node("/root/Global")
@onready var stored_amount = $StoredAmount
@onready var stored_sprite = $StoredSprite

@export var resource_scene: PackedScene
@export var copper_scene: PackedScene
@export var resource_ingot_scene: PackedScene
@export var copper_ingot_scene: PackedScene
@export var resource_rod_scene: PackedScene
@export var copper_wire_scene: PackedScene
@export var circuit_board_scene: PackedScene
var clone = 0
var direction = 0
var delete = 0
var pos = Vector2i(0,0)
var bitmap: BitMap = BitMap.new()
var item_type = ""
var amount = 1
var has_item = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if clone == 0 and global.slot == 5:
		position = get_global_mouse_position().snapped(Vector2(16,16))
		position.x -= 8
		position.y -= 8
	if Input.is_action_just_pressed("Rotate(R)") and not clone:
		rotation_degrees += 90
	if Input.is_action_pressed("Right_click") and clone and delete == 1:
		queue_free()
	if clone == 1 and amount >=1:
		#if get_child(1).frame == 1:
			#if not $RayCast2D.get_collider():
				#var resource = copper_scene.instantiate()
				#resource.position = position
				#resource.modulate.a = 1
				#resource.rotation_degrees = rotation_degrees+90
				#resource.direction = rotation/90
				#resource.set_meta("Resource", direction/90)
				#add_sibling(resource)
				#resource.clone = 1
				#amount-=1
		#if get_child(1).frame == 2:
			#if not $RayCast2D.get_collider():
				#var resource = copper_ingot_scene.instantiate()
				#resource.position = position
				#resource.modulate.a = 1
				#resource.rotation_degrees = rotation_degrees+90
				#resource.direction = rotation/90
				#resource.set_meta("Resource", direction/90)
				#add_sibling(resource)
				#resource.clone = 1
				#amount-=1
		#if get_child(1).frame == 3:
			#if not $RayCast2D.get_collider():
				#var resource = copper_wire_scene.instantiate()
				#resource.position = position
				#resource.modulate.a = 1
				#resource.rotation_degrees = rotation_degrees+90
				#resource.direction = rotation/90
				#resource.set_meta("Resource", direction/90)
				#add_sibling(resource)
				#resource.clone = 1
				#amount-=1
		#if get_child(1).frame == 4:
			#if not $RayCast2D.get_collider():
				#var resource = resource_scene.instantiate()
				#resource.position = position
				#resource.modulate.a = 1
				#resource.rotation_degrees = rotation_degrees+90
				#resource.direction = rotation/90
				#resource.set_meta("Resource", direction/90)
				#add_sibling(resource)
				#resource.clone = 1
				#amount-=1
		#if get_child(1).frame == 5:
			#if not $RayCast2D.get_collider():
				#var resource = resource_ingot_scene.instantiate()
				#resource.position = position
				#resource.modulate.a = 1
				#resource.rotation_degrees = rotation_degrees+90
				#resource.direction = rotation/90
				#resource.set_meta("Resource", direction/90)
				#add_sibling(resource)
				#resource.clone = 1
				#amount-=1
		#if get_child(1).frame == 6:
			#if not $RayCast2D.get_collider():
				#var resource = resource_rod_scene.instantiate()
				#resource.position = position
				#resource.modulate.a = 1
				#resource.rotation_degrees = rotation_degrees+90
				#resource.direction = rotation/90
				#resource.set_meta("Resource", direction/90)
				#add_sibling(resource)
				#resource.clone = 1
				#amount-=1
		if amount == 0: 
			has_item = false
	if clone == 0:
		if global.slot == 5:
			show()
		else:
			hide()


func _on_area_entered(area):
	if area.has_meta("Type") and clone == 1:
		stored_amount.text = (str(int(amount)))
		if not has_item:
			has_item = true
			stored_sprite.show()
			item_type = area.get_meta("Type")
			stored_sprite.frame = area.get_meta("Type")
			amount += 1
		else:
			amount+=1


func _on_mouse_entered():
	delete = 1


func _on_mouse_exited():
	delete = 0


func _on_body_entered(_body):
	if clone == 0:
		var map = get_tree().current_scene.get_node("Generated_map")
		var cell = map.local_to_map(position/2)
		var data = map.get_cell_tile_data(cell)
		if not data.get_custom_data("World") == "Unplaceable":
			global.buildings_cant_place = false
		else:
			global.buildings_cant_place = true
