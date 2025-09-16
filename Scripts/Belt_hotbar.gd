extends Button

@onready var global = get_node("/root/Global")


func _on_belt_selected():
	if global.hotbar_pressed == 1:
		global.hotbar_pressed = 0
	else:
		global.hotbar_pressed = 1
