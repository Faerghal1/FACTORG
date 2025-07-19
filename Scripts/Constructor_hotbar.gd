extends Button

@onready var global = get_node("/root/Global")


func _on_constructor_selected():
	global.mouse_entered_constructor = true
	global.mouse_entered_extractor = false
	global.mouse_entered_belt = false
	global.mouse_entered_smelter = false
