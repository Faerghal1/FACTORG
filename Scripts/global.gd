extends Node

var width = 500 # effective change in loading screen.gd
var height = 500 # effective change in loading screen.gd
var bitmap: BitMap = BitMap.new()
var mouse_entered_belt = false
var mouse_entered_extractor = false
var mouse_entered_smelter = false
var mouse_entered_constructor = false
var mouse_entered_storage = false
var belt = false
var extractor = false
var smelter = false
var constructor = false
var storage = false
var rod = 0
var ingot = 0
var iron_ore = 0
var copper_ore = 0
var extractor_placed = false
var slot = 0
