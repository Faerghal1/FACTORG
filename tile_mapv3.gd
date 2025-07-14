extends Node2D

@export var width = 600
@export var height = 600
@onready var tilemap = $TileMap
var temperature = {}
var altitude = {}
var biome = {}
var fastNoiseLite = FastNoiseLite.new
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
