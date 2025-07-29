extends Button

@onready var global = get_node("/root/Global")


func _on_smelter_selected():
	global.slot = 3
