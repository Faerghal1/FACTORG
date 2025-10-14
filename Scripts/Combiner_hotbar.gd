extends Button

@onready var global: Node = get_node("/root/Global")


func _on_combiner_selected():
	if global.hotbar_slot == global.slot.NONE:
		global.hotbar_slot = global.slot.COMBINER
	else:
		global.hotbar_slot = global.slot.NONE
