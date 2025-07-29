extends Button

@onready var global = get_node("/root/Global")


func _on_storage_selected():
	global.slot = 5
