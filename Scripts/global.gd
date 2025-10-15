extends Node

var width: int = 500 # effective change in loading screen.gd
var height: int = 500 # effective change in loading screen.gd
var bitmap: BitMap = BitMap.new()
var iron_ore: int = 0
var copper_ore: int = 0
var gold_ore: int = 0
var ingot: int = 0
var copper_ingot: int = 0
var gold_ingot: int = 0
var rod: int = 0
var copper_foil: int = 0
var gold_wire: int = 0
var circuit_board: int = 0
var metal_frame: int = 0
var extractor_placed: bool = false
# Numerical list of all placeable objects starting from 0 and ending at 6
enum slot {
	NONE,
	BELT,
	EXTRACTOR,
	SMELTER,
	CONSTRUCTOR,
	STORAGE,
	COMBINER,
}
var hotbar_pressed: int = 0
var extractor_cant_place: bool = true
var buildings_cant_place: bool = true
var buildings_large_cant_place: bool = true
var mouse_on_hotbar: bool = false
var frames: int = 0
var seed: int = 0
var hotbar_slot: int = 0
