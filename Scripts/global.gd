extends Node

var width = 500 # effective change in loading screen.gd
var height = 500 # effective change in loading screen.gd
var bitmap: BitMap = BitMap.new()
var iron_ore = 0
var copper_ore = 0
var gold_ore = 0
var ingot = 0
var copper_ingot = 0
var gold_ingot = 0
var rod = 0
var copper_foil = 0
var gold_wire = 0
var extractor_placed = false
var slot = 0
var hotbar_pressed = 0
var extractor_cant_place = true
var buildings_cant_place = true
var buildings_large_cant_place = true
var mouse_on_hotbar = false
var frames = 0 # Controls what frame the conveyer belt is.
