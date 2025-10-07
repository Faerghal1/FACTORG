extends Button

@onready var global = get_node("/root/Global")


func _on_combiner_selected():
	if global.hotbar_pressed == 6:
		global.hotbar_pressed = 0
	else:
		global.hotbar_pressed = 6
