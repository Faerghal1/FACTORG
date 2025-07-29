extends Button

@onready var global = get_node("/root/Global")


func _on_extractor_selected():
	global.slot = 2
