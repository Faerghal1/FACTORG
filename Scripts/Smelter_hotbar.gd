extends Button

@onready var global: Node = get_node("/root/Global")


func _on_smelter_selected():
	if global.hotbar_pressed == 0:
		global.hotbar_pressed = 3
	else:
		global.hotbar_pressed = 0
