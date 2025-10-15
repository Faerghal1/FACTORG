extends Button

@onready var global: Node = get_node("/root/Global")


func _on_constructor_selected():
	# Toggles global.hotbar_slot to be either 0 or 4 indicating either null or Constructor
	if global.hotbar_slot == global.slot.NONE:
		global.hotbar_slot = global.slot.CONSTRUCTOR
	else:
		global.hotbar_slot = global.slot.NONE
