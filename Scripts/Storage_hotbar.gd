extends Button

@onready var global: Node = get_node("/root/Global")


func _on_storage_selected():
	if global.hotbar_slot == global.slot.NONE:
		global.hotbar_slot = global.slot.STORAGE
	else:
		global.hotbar_slot = global.slot.NONE
