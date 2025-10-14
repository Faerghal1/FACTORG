extends Node2D

@onready var global = get_node("/root/Global")
const SAVE_SEED = "user://game_seed.json"

func _ready() :
	load_seed()


func _process(delta: float) -> void:
	get_tree().change_scene_to_file("res://Scenes/Main_menu.tscn")


func load_seed():
	if FileAccess.file_exists(SAVE_SEED):
		var file = FileAccess.open(SAVE_SEED, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			var parse_result = JSON.parse_string(json_string)
			if parse_result is Dictionary:
				var loaded_data = parse_result
				global.seed = loaded_data.get("Seed", 0)
				return loaded_data
			else:
				print("Error parsing JSON data")
		else:
			print("Error opening file to load seed")
	else:
		print("Save file does not exist")
	return {}
