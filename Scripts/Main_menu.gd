extends Node2D

	
# Called when the node enters the sce	ne tree for the first time.
func _ready() :
	$Node2D/GeneratedMap.height = 2
	$Node2D/GeneratedMap.width = 10 #this does not change the tilemap size:(
	$Camera2D.temppos_x = 0
	$Camera2D.temppos_y = 24 * 8
	#ResourceLoader.load_threaded_request("res://Scenes/World.tscn")
	#get_tree().change_scene_to_packed(load("res://Scenes/World.tscn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://Scenes/Loading_screen.tscn"))# as scene is large loading time is big
# project freezes for 10secs
