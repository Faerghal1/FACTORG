extends Node2D

@onready var global: Node = get_node("/root/Global")

const MAIN_MENU_SIZE: int = 200


# Called when the node enters the scene tree for the first time.
func _ready() :
	global.height = MAIN_MENU_SIZE # This does not change the tilemap size
	global.width = MAIN_MENU_SIZE # This does not change the tilemap size


func _on_start_button_pressed() -> void:
	# As scene is large loading time is big, so project freezes for sometime before loading
	get_tree().change_scene_to_packed(load("res://Scenes/Loading_screen.tscn"))


func _on_quit_button_pressed():
	get_tree().quit()


func _on_new_seed_button_pressed() -> void:
	global.seed += 1
	get_tree().change_scene_to_file("res://Scenes/Main_menu.tscn")
