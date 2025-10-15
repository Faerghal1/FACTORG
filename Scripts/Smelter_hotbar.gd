extends Button

@onready var global: Node = get_node("/root/Global")


func _on_smelter_selected():
	# Toggles global.hotbar_slot to be either 0 or 3 indicating either null or Smelter
	if global.hotbar_slot == global.slot.NONE:
		global.hotbar_slot = global.slot.SMELTER
	else:
		global.hotbar_slot = global.slot.NONE
