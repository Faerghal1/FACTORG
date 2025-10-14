extends Button

@onready var global: Node = get_node("/root/Global")


func _on_belt_selected():
	if global.hotbar_slot == global.slot.NONE:
		global.hotbar_slot = global.slot.BELT
	else:
		global.hotbar_slot = global.slot.NONE
