extends Node2D

@export var noise_height_texture : NoiseTexture2D

var noise : Noise
var width : int = 100
var height : int = 150
@onready var tile_map = $TileMap

var source_id = 0
var water_atlas = Vector2i(3,0)
var land_atlas = Vector2i(1,1)
# Called when the node enters the scene tree for the first time.
func _ready():
	noise = noise_height_texture.noise
	generate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate():
	for x in range(width):
		for y in range(height):
			var noise_val = noise.get_noise_2d(x,y)
			if noise_val >= 0:
				tile_map.set_cell(0, Vector2(x,y), source_id, land_atlas)
				pass
			elif noise_val < 0.0:
				tile_map.set_cell(0, Vector2(x,y), source_id, water_atlas)
				pass
