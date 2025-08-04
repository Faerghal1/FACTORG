extends Node2D

@onready var global = get_node("/root/Global")

# Called when the node enters the sce	ne tree for the first time.
func _ready() :
	global.height = 200
	global.width = 200 #this does not change the tilemap size:(


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://Scenes/Loading_screen.tscn"))
# as scene is large loading time is big
# project freezes for 10secs


func _on_quit_button_pressed():
	get_tree().quit()
