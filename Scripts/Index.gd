extends Control

var Recipe = 0


func _process(_delta):
	if Recipe == 1:
		$IronOre.show()
	if Recipe == 2:
		$CopperOre.show()
	if Recipe == 3:
		$IronIngot.show()
	if Recipe == 4:
		$CopperIngot.show()
	if Recipe == 5:
		$IronRod.show()
	if Recipe == 6:
		$CopperWire.show()


func _on_iron_ore_mouse_entered():
	Recipe = 1


func _on_copper_ore_mouse_entered():
	Recipe = 2


func _on_iron_ingot_mouse_entered():
	Recipe = 3


func _on_copper_ingot_mouse_entered():
	Recipe = 4


func _on_iron_rod_mouse_entered():
	Recipe = 5


func _on_copper_wire_mouse_entered():
	Recipe = 6
