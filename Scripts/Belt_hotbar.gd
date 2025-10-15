extends Button

@onready var global: Node = get_node("/root/Global")


func _on_belt_selected():
	# Toggles global.hotbar_slot to be either 0 or 1 indicating either null or Belt
	if global.hotbar_slot == global.slot.NONE:
		global.hotbar_slot = global.slot.BELT
	else:
		global.hotbar_slot = global.slot.NONE
