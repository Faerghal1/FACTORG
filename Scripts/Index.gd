extends Control

@onready var ironore = $IronOre
@onready var copperore = $CopperOre
@onready var ironingot = $IronIngot
@onready var copperingot = $CopperIngot
@onready var ironrod = $IronRod
@onready var copperwire = $CopperWire
@onready var copperfoil = $CopperFoil
var recipe = 0


func _process(_delta):
	if recipe == 1:
		ironore.show()
	if recipe == 2:
		copperore.show()
	if recipe == 3:
		ironingot.show()
	if recipe == 4:
		copperingot.show()
	if recipe == 5:
		ironrod.show()
	if recipe == 6:
		copperwire.show()
	if recipe == 7:
		copperfoil.show()
	if not recipe == 1:
		ironore.hide()
	if not recipe == 2:
		copperore.hide()
	if not recipe == 3:
		ironingot.hide()
	if not recipe == 4:
		copperingot.hide()
	if not recipe == 5:
		ironrod.hide()
	if not recipe == 6:
		copperwire.hide()
	if not recipe == 7:
		copperfoil.hide()


func _on_iron_ore_mouse_entered():
	recipe = 1


func _on_copper_ore_mouse_entered():
	recipe = 2


func _on_iron_ingot_mouse_entered():
	recipe = 3


func _on_copper_ingot_mouse_entered():
	recipe = 4


func _on_iron_rod_mouse_entered():
	recipe = 5


func _on_copper_wire_mouse_entered():
	recipe = 6


func _on_copper_foil_mouse_entered():
	recipe = 7
