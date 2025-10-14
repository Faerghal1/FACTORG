extends Button

@onready var global: Node = get_node("/root/Global")


func _on_combiner_selected():
	if global.hotbar_pressed == 0:
		global.hotbar_pressed = 6
	else:
		global.hotbar_pressed = 0
