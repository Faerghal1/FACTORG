extends Control


func _on_iron_ore_pressed():
	if $IronOre.visible == false:
		$IronOre.show()
	else:
		$IronOre.hide()


func _on_copper_ore_pressed():
	pass # Replace with function body.


func _on_iron_ingot_pressed():
	pass # Replace with function body.


func _on_copper_ingot_pressed():
	pass # Replace with function body.


func _on_iron_rod_pressed():
	pass # Replace with function body.


func _on_copper_wire_pressed():
	pass # Replace with function body.
