extends Button

@onready var global: Node = get_node("/root/Global")


func _on_extractor_selected():
	# Toggles global.hotbar_slot to be either 0 or 2 indicating either null or Extractor
	if global.hotbar_slot == global.slot.NONE:
		global.hotbar_slot = global.slot.EXTRACTOR
	else:
		global.hotbar_slot = global.slot.NONE
