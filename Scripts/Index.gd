extends Control

@onready var iron_ore: Control = $IronOre
@onready var copper_ore: Control = $CopperOre
@onready var gold_ore: Control = $GoldOre
@onready var iron_ingot: Control = $IronIngot
@onready var copper_ingot: Control = $CopperIngot
@onready var gold_ingot: Control = $GoldIngot
@onready var iron_rod: Control = $IronRod
@onready var copper_foil: Control = $CopperFoil
@onready var gold_wire: Control = $GoldWire
@onready var circuit_board: Control = $CircuitBoard
@onready var metal_frame: Control = $MetalFrame

var recipe: int = 0
# Numerical list of all resources starting from 1 ending at 11
enum recipe_list {
	IRON_ORE = 1,
	COPPER_ORE,
	GOLD_ORE,
	IRON_INGOT,
	COPPER_INGOT,
	GOLD_INGOT,
	IRON_ROD,
	COPPER_FOIL,
	GOLD_WIRE,
	CIRCUIT_BOARD,
	METAL_FRAME,
}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# If user has hovered over Iron_ore in the index, show Iron_ore information
	if recipe == recipe_list.IRON_ORE:
		iron_ore.show()
	else: 
		iron_ore.hide()
	# If user has hovered over Copper_ore in the index, show Copper_ore information
	if recipe == recipe_list.COPPER_ORE:
		copper_ore.show()
	else:
		copper_ore.hide()
	# If user has hovered over Gold_ore in the index, show Gold_ore information
	if recipe == recipe_list.GOLD_ORE:
		gold_ore.show()
	else:
		gold_ore.hide()
	# If user has hovered over Iron_ingot in the index, show Iron_ingot information
	if recipe == recipe_list.IRON_INGOT:
		iron_ingot.show()
	else:
		iron_ingot.hide()
	# If user has hovered over Copper_ingot in the index, show Copper_ingot information
	if recipe == recipe_list.COPPER_INGOT:
		copper_ingot.show()
	else:
		copper_ingot.hide()
	# If user has hovered over Gold_ingot in the index, show Gold_ingot information
	if recipe == recipe_list.GOLD_INGOT:
		gold_ingot.show()
	else:
		gold_ingot.hide()
	# If user has hovered over Iron_rod in the index, show Iron_rod information
	if recipe == recipe_list.IRON_ROD:
		iron_rod.show()
	else:
		iron_rod.hide()
	# If user has hovered over Copper_foil in the index, show Copper_foil information
	if recipe == recipe_list.COPPER_FOIL:
		copper_foil.show()
	else:
		copper_foil.hide()
	# If user has hovered over Gold_wire in the index, show Gold_wire information
	if recipe == recipe_list.GOLD_WIRE:
		gold_wire.show()
	else:
		gold_wire.hide()
	# If user has hovered over Circuit_board in the index, show Circuit_board information
	if recipe == recipe_list.CIRCUIT_BOARD:
		circuit_board.show()
	else:
		circuit_board.hide()
	# If user has hovered over Metal_frame in the index, show Metal_frame information
	if recipe == recipe_list.METAL_FRAME:
		metal_frame.show()
	else:
		metal_frame.hide()


func _on_iron_ore_mouse_entered():
	recipe = recipe_list.IRON_ORE


func _on_copper_ore_mouse_entered():
	recipe = recipe_list.COPPER_ORE


func _on_gold_ore_mouse_entered():
	recipe = recipe_list.GOLD_ORE


func _on_iron_ingot_mouse_entered():
	recipe = recipe_list.IRON_INGOT


func _on_copper_ingot_mouse_entered():
	recipe = recipe_list.COPPER_INGOT


func _on_gold_ingot_mouse_entered():
	recipe = recipe_list.GOLD_INGOT


func _on_iron_rod_mouse_entered():
	recipe = recipe_list.IRON_ROD


func _on_copper_foil_mouse_entered():
	recipe = recipe_list.COPPER_FOIL


func _on_gold_wire_mouse_entered():
	recipe = recipe_list.GOLD_WIRE


func _on_circuit_board_mouse_entered():
	recipe = recipe_list.CIRCUIT_BOARD


func _on_metal_frame_mouse_entered():
	recipe = recipe_list.METAL_FRAME
