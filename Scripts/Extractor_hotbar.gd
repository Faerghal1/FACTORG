extends Button

@onready var global = get_node("/root/Global")


func _on_extractor_selected():
	global.mouse_entered_extractor = true
	global.mouse_entered_belt = false
	global.mouse_entered_refiner = false
