extends Button

@onready var global = get_node("/root/Global")


func _on_constructor_selected():
	global.slot = 4
