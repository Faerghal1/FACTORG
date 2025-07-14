extends Button

@onready var global = get_node("/root/Global")


func _on_belt_selected():
	global.mouse_entered_belt = true
	global.mouse_entered_extractor = false
