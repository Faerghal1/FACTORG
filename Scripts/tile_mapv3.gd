extends Node2D

@export var width = 600
@export var height = 600
@onready var tilemap = $TileMap
var temperature = {}
var moisture = {}
var altitude = {}
var biome = {}
var fastNoiseLite = FastNoiseLite.new()


func generate_map(per,oct):
	fastNoiseLite.seed = randi()

	var gridName = {}
	for x in width:
		for y in height:
			var rand = 2*(abs(fastNoiseLite.get_noise_2d(x,y)))
			gridName[Vector2(x,y)] = rand
	return gridName

# Called when the node enters the scene tree for the first time.
func _ready():
	temperature = generate_map(300, 5)
	moisture = generate_map(300,5)
	altitude = generate_map(150,5)
	set_tile(width,height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#var noise: FastNoiseLite = FastNoiseLite.new()
#noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
#noise.seed = randi()

#var value = noise.noise.get_noise_2d(x, y)

#var noise = OpenSimplexNoise.new()
#noise.seed = randi()
#noise.octaves = 2
#noise.period = 10.0
#noise.persistence = 0.8
#var value = noise.get_noise_2d(x, y)

func set_tile(width, height):
	for x in width:
		for y in height:
			var pos = Vector2(x, y)
			var alt = altitude[pos]
			var temp = temperature[pos]
			var moist = moisture[pos]
			
#			ocean
			if alt <0.1:
				tilemap.set_cell(0, Vector2i(x,y), 0, Vector2i(0,2))
			else:
				tilemap.set_cell(0, Vector2i(x,y), 0, Vector2i(1,0))
