extends Area2D

@onready var global = get_node("/root/Global")

func _on_mouse_entered_extractor(area):
	if area.has_meta("Extractor"):
		global.mouse_entered_extractor = true


func _on_mouse_exited_extractor(area):
	pass
