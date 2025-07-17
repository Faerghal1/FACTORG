extends TileMap

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var width = 1000
var height = 1000
var biome = {}
@onready var player = get_parent().get_child(1)



var objects = {}


var tiles = {"grass": Vector2i(0,0), "jungle_grass": Vector2i(1,0), "sand": Vector2i(1,1), "water": Vector2i(0,2), "snow": Vector2i(0,1), "stone": Vector2i(2,1)}


var object_tiles = {"tree": preload("res://Scenes/Tree.tscn"), "cactus": preload("res://Scenes/Cactus.tscn"), \
"spruce_tree": preload("res://Scenes/Spruce_tree.tscn")}


var biome_data = {
	"plains": {"grass": 1},
	"beach": {"sand": 0.99, "stone": 0.01}, 
	"jungle": {"jungle_grass": 1},
	"desert": {"sand": 0.98, "stone": 0.02}, 
	"lake": {"water": 1},
	"mountain": {"stone": 0.98, "grass":0.02},
	"snow": {"snow": 0.96, "stone": 0.02, "grass": 0.02},
	"ocean":{"water": 1}
}

var object_data = {
	"plains": {"tree": 0.03},
	"beach": {"tree": 0.01}, 
	"jungle": {"tree": 0.04},
	"desert": {"cactus": 0.03}, 
	"lake": {},
	"mountain": {"spruce_tree":0.02},
	"snow": {"spruce_tree": 0.02},
	"ocean":{}
}


func random_tile(data, biome):
	var current_biome = data[biome]
	var rand_num = randf()
	var running_total = 0
	for tile in current_biome:
			running_total = running_total+current_biome[tile]
			if rand_num <= running_total:
				return tile

# Called when the node enters the scene tree for the first time.
func _ready():
	moisture.seed = randi() # Having three randi so that they are unique
	temperature.seed = randi()
	altitude.seed = randi()
	generate_chunk(player.position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func generate_chunk(position):
	var tile_pos = local_to_map(position) # gets the position in tilemap coords
	for x in range (width):
		for y in range(height):

			var pos = Vector2(x,y)
			var moist = moisture.get_noise_2d(tile_pos.x + x - width/2, tile_pos.y + y - height/2)
			var temp = temperature.get_noise_2d(tile_pos.x + x - width/2, tile_pos.y + y - height/2)
			var alt = altitude.get_noise_2d(tile_pos.x + x - width/2, tile_pos.y + y - height/2)
			#if alt < -3: #generates water is altitude is too low
				#set_cell(0, Vector2i(tile_pos.x + x - width/2, tile_pos.y + y - height/2), 0, Vector2i(3,round((temp+10)/5)))
			#else:
				#set_cell(0, Vector2i(tile_pos.x + x - width/2, tile_pos.y + y - height/2), 0, Vector2i(round((moist+4)/5),round((temp+10)/5)))
		#Ocean
			if alt < -0.4:
				set_cell(0, Vector2i(tile_pos.x + x - width/2, tile_pos.y + y - height/2), 0, Vector2i(0,2))
			
			#Beach
			elif alt < -0.3:
				biome[pos] = "beach"
				set_cell(0, Vector2i(tile_pos.x + x - width/2, tile_pos.y + y - height/2), 0, \
				tiles[random_tile(biome_data, "beach")])

			#Other Biomes
			elif alt < 0.7:
				#plains
				if moist > -0.5 and moist < 0.5 and temp > -0.3 and temp < 0.4:
					biome[pos] = "plains"
					set_cell(0, Vector2i(tile_pos.x + x - width/2, tile_pos.y + y - height/2), 0, \
					tiles[random_tile(biome_data, "plains")])
				#jungle
				elif  moist > 0.4 and moist < 0.9 and temp > 0.6:
					biome[pos] = "jungle"
					set_cell(0, Vector2i(tile_pos.x + x - width/2, tile_pos.y + y - height/2), 0, \
					tiles[random_tile(biome_data, "jungle")])
				#desert
				elif temp > 0.6 and moist < 0.3:
					biome[pos] = "desert"
					set_cell(0, Vector2i(tile_pos.x + x - width/2, tile_pos.y + y - height/2), 0, \
					tiles[random_tile(biome_data, "desert")])
				#lakes
				elif moist >= 0.5:
					biome[pos] = "lake"
					set_cell(0, Vector2i(tile_pos.x + x - width/2, tile_pos.y + y - height/2), 0, \
					tiles[random_tile(biome_data, "lake")])
			#Mountains
			elif  moist > 0.7 and moist < 0.8:
				biome[pos] = "mountain"
				set_cell(0, Vector2i(tile_pos.x + x - width/2, tile_pos.y + y - height/2), 0, \
				tiles[random_tile(biome_data, "mountain")])
			#Snow
			else:
				biome[pos] = "snow"
				#set_cell(pos, tiles[random_tile(biome_data,"snow")])
				set_cell(0, Vector2i(tile_pos.x + x - width/2, tile_pos.y + y - height/2), 0, \
				tiles[random_tile(biome_data, "snow")])
