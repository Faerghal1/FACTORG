extends Button

@onready var global: Node = get_node("/root/Global")


func _on_combiner_selected():
	# Toggles global.hotbar_slot to be either 0 or 6 indicating either null or Combiner
	if global.hotbar_slot == global.slot.NONE:
		global.hotbar_slot = global.slot.COMBINER
	else:
		global.hotbar_slot = global.slot.NONE
