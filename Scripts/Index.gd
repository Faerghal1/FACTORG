extends Control

@onready var iron_ore = $IronOre
@onready var copper_ore = $CopperOre
@onready var gold_ore = $GoldOre
@onready var iron_ingot = $IronIngot
@onready var copper_ingot = $CopperIngot
@onready var gold_ingot = $GoldIngot
@onready var iron_rod = $IronRod
@onready var copper_foil = $CopperFoil
@onready var gold_wire = $GoldWire
@onready var circuit_board = $CircuitBoard

var recipe = 0


func _process(_delta):
	if recipe == 1:
		iron_ore.show()
	if recipe == 2:
		copper_ore.show()
	if recipe == 3:
		gold_ore.show()
	if recipe == 4:
		iron_ingot.show()
	if recipe == 5:
		copper_ingot.show()
	if recipe == 6:
		gold_ingot.show()
	if recipe == 7:
		iron_rod.show()
	if recipe == 8:
		copper_foil.show()
	if recipe == 9:
		gold_wire.show()
	if recipe == 10:
		circuit_board.show()
	if not recipe == 1:
		iron_ore.hide()
	if not recipe == 2:
		copper_ore.hide()
	if not recipe == 3:
		gold_ore.hide()
	if not recipe == 4:
		iron_ingot.hide()
	if not recipe == 5:
		copper_ingot.hide()
	if not recipe == 6:
		gold_ingot.hide()
	if not recipe == 7:
		iron_rod.hide()
	if not recipe == 8:
		copper_foil.hide()
	if not recipe == 9:
		gold_wire.hide()
	if not recipe == 10:
		circuit_board.hide()


func _on_iron_ore_mouse_entered():
	recipe = 1


func _on_copper_ore_mouse_entered():
	recipe = 2


func _on_gold_ore_mouse_entered():
	recipe = 3


func _on_iron_ingot_mouse_entered():
	recipe = 4


func _on_copper_ingot_mouse_entered():
	recipe = 5


func _on_gold_ingot_mouse_entered():
	recipe = 6


func _on_iron_rod_mouse_entered():
	recipe = 7


func _on_copper_foil_mouse_entered():
	recipe = 8


func _on_gold_wire_mouse_entered():
	recipe = 9


func _on_circuit_board_mouse_entered():
	recipe = 10
