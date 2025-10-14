extends Node2D

@onready var global: Node = get_node("/root/Global")

const MAIN_MENU_SIZE: int = 200


# Called when the node enters the scene tree for the first time.
func _ready() :
	global.height = MAIN_MENU_SIZE
	global.width = MAIN_MENU_SIZE #this does not change the tilemap size:(


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://Scenes/Loading_screen.tscn"))
# as scene is large loading time is big
# project freezes for 10secs


func _on_quit_button_pressed():
	get_tree().quit()


func _on_new_save_button_button_up() -> void:
	global.seed += 1
	get_tree().change_scene_to_file("res://Scenes/Main_menu.tscn")
