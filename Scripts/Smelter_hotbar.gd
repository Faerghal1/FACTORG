extends Button

@onready var global: Node = get_node("/root/Global")


func _on_smelter_selected():
	if global.hotbar_slot == global.slot.NONE:
		global.hotbar_slot = global.slot.SMELTER
	else:
		global.hotbar_slot = global.slot.NONE
