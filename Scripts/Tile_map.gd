extends TileMapLayer

@onready var player: Node = get_parent().get_child(1)
@onready var global: Node = get_node("/root/Global")

var moisture: FastNoiseLite = FastNoiseLite.new()
var temperature: FastNoiseLite = FastNoiseLite.new()
var altitude: FastNoiseLite = FastNoiseLite.new()
var biome: Dictionary = {}
var objects: Dictionary = {}
var tiles: Dictionary = {
	"grass": Vector2i(0,0), "grass_tree": Vector2i(0,2),
	"grass_rock": Vector2i(0,1), "grass_boulder": Vector2i(0,3),
	"grass_iron": Vector2i(0,4),"grass_copper": Vector2i(0,5),

	"jungle_grass": Vector2i(1,0), "jungle_tree": Vector2i(1,2),
	"jungle_rock": Vector2i(1,1), "jungle_boulder": Vector2i(1,3),
	"jungle_copper": Vector2i(1,5), "jungle_apple_tree": Vector2i(1,10), 

	"spruce_grass": Vector2i(2,0), "spruce_tree": Vector2i(2,2),
	"spruce_rock": Vector2i(2,1), "spruce_boulder": Vector2i(2,3),
	"spruce_iron": Vector2i(2,4), 

	"swamp_grass": Vector2i(3,0), "swamp_tree": Vector2i(3,2),
	"swamp_rock": Vector2i(3,1), "swamp_boulder": Vector2i(3,3),
	"swamp_iron": Vector2i(3,4),"swamp_copper": Vector2i(3,5), 

	"dark_oak_grass": Vector2i(4,0), "dark_oak_tree": Vector2i(4,2),
	"dark_oak_rock": Vector2i(4,1), "dark_oak_boulder": Vector2i(4,3),
	"dark_oak_copper": Vector2i(4,5), 

	"snow_grass": Vector2i(5,0), "snow_tree": Vector2i(5,2),
	"snow_rock": Vector2i(5,1), "snow_boulder": Vector2i(5,3),
	"snow_iron": Vector2i(5,4),

	"water": Vector2i(6,0),

	"mud_grass": Vector2i(7,0), "mud_tree": Vector2i(7,2),
	"mud_rock": Vector2i(7,1), "mud_boulder": Vector2i(7,3),

	"deep_water": Vector2i(8,0),

	"sand": Vector2i(9,0),"sand_cactus_1": Vector2i(9,2), 
	"sand_cactus_2": Vector2i(9,3), "sand_cactus_3": Vector2i(9,10), 
	"sand_rock": Vector2i(9,1), "sand_boulder": Vector2i(9,0),
	"sand_gold": Vector2i(9,6),

	"stone": Vector2i(10,0)
	}
var biome_data: Dictionary = {
	"plains": {"grass": 0.8, "grass_tree": 0.15, "grass_rock": 0.025, "grass_boulder": 0.0125,
	"grass_iron": 0.00625, "grass_copper": 0.00625},
			
	"jungle": {"jungle_grass": 0.6, "jungle_tree": 0.27, "jungle_apple_tree": 0.05,
	 "jungle_rock": 0.01 , "jungle_boulder": 0.02, "jungle_copper": 0.05},
	
	"spruce": {"spruce_grass": 0.8, "spruce_tree": 0.15, "spruce_rock": 0.025, 
	"spruce_boulder": 0.0125, "spruce_iron": 0.0125},
	
	"swamp": {"swamp_grass": 0.806, "swamp_tree": 0.19, "swamp_rock": 0.001, 
	"swamp_boulder": 0.001, "swamp_iron": 0.001, "swamp_copper": 0.001},
	
	"dark_oak": {"dark_oak_grass": 0.83, "dark_oak_tree": 0.15, "dark_oak_rock": 0.005, 
	"dark_oak_boulder": 0.005, "dark_oak_copper": 0.01},
	
	"snow": {"snow_grass": 0.8, "snow_tree": 0.15, "snow_rock": 0.025, "snow_boulder": 0.0125,
	"snow_iron": 0.0125},
	
	"lake": {"water": 1},
	
	"mud": {"mud_grass": 0.806, "mud_tree": 0.19, "mud_rock": 0.002, "mud_boulder": 0.002},
	
	"ocean":{"deep_water": 1},
	
	"desert": {"sand": 0.8, "sand_rock": 0.02, "sand_cactus_1": 0.04, "sand_cactus_2": 0.04, 
	"sand_cactus_3": 0.04, "sand_boulder": 0.04, "sand_gold": 0.02},
	
	"mountain": {"stone": 0.98, "grass":0.02},

	"beach":  {"sand": 0.99, "stone": 0.01},
	}
var object_data: Dictionary = {
	"plains": {"tree": 0.03},
	"beach": {"tree": 0.01}, 
	"jungle": {"tree": 0.04},
	"desert": {"cactus": 0.03}, 
	"lake": {},
	"mountain": {"spruce_tree":0.02},
	"snow": {"spruce_tree": 0.02},
	"ocean":{}
}
const SAVE_SEED: String = "user://game_seed.json"

func random_tile(data, biome):
	var current_biome = data[biome]
	var rand_num = randf()
	var running_total = 0
	for tile in current_biome:
		running_total = running_total + current_biome[tile]
		if rand_num <= running_total:
			return tile


# Called when the node enters the scene tree for the first time.
func _ready():
	print(global.seed)
	seed(global.seed)
	moisture.seed = randi() # Having three randi so that they are unique
	temperature.seed = randi()
	altitude.seed = randi()
	generate_chunk(player.position)
	print(global.seed)


func load_seed():
	if FileAccess.file_exists(SAVE_SEED):
		var file = FileAccess.open(SAVE_SEED, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			var parse_result = JSON.parse_string(json_string)
			if parse_result is Dictionary:
				var loaded_data = parse_result
				global.seed = loaded_data.get("Seed", 0)
				return loaded_data
			else:
				print("Error parsing JSON data")
		else:
			print("Error opening file to load seed")
	else:
		print("Save file does not exist")
	return {}


func generate_chunk(position):
	var tile_pos = local_to_map(position) # gets the position in tilemap coords
	for x in global.width:
		for y in global.height:
			var pos = Vector2(x,y)
			var moist = moisture.get_noise_2d(x, y)
			var temp = temperature.get_noise_2d(x, y)
			var alt = altitude.get_noise_2d(x, y)
			#Ocean
			if alt < -0.4:
				biome[pos] = "ocean"
				set_cell(Vector2i(x, y), 0,
				tiles[random_tile(biome_data, "ocean")])
			#Beach
			elif alt < -0.3:
				biome[pos] = "beach"
				set_cell(Vector2i(x, y), 0,
				tiles[random_tile(biome_data, "beach")])
			#Other Biomes
			elif alt < 0.7:
				#plains
				if moist <= 0.5 and temp <= 0.1 and temp > -0.1:
					biome[pos] = "plains"
					set_cell(Vector2i(x, y), 0,
					tiles[random_tile(biome_data, "plains")])
				#jungle
				elif  moist > 0.0 and moist <= 1.0 and temp > 0.5:
					biome[pos] = "jungle"
					set_cell(Vector2i(x, y), 0,
					tiles[random_tile(biome_data, "jungle")])
				#desert
				elif temp > 0.2 and moist <= 0.0:
					biome[pos] = "desert"
					set_cell(Vector2i(x, y), 0,
					tiles[random_tile(biome_data, "desert")])
				#lakes
				elif moist <= 1.0 and moist > 0.6 and temp <= -0.4 and temp > -0.7:
					biome[pos] = "lake"
					set_cell(Vector2i(x, y), 0,
					tiles[random_tile(biome_data, "lake")])
				#Swamp
				elif temp > -0.3 and temp <= 0.4 and moist > 0.6:
					biome[pos] = "swamp"
					set_cell(Vector2i(x, y), 0,
					tiles[random_tile(biome_data, "swamp")])
				#Mud
				elif moist <= 0.5 and moist > 0.0 and temp <= 0.4 and temp >0.2:
					biome[pos] = "mud"
					set_cell(Vector2i(x, y), 0,
					tiles[random_tile(biome_data, "mud")])
				#spruce
				elif moist <= 0.5 and temp > -0.7 and temp<= -0.2:
					biome[pos] = "spruce"
					set_cell(Vector2i(x, y), 0,
					tiles[random_tile(biome_data, "spruce")])
				else :
					biome[pos] = "snow"
					set_cell(Vector2i(x, y), 0,
					tiles[random_tile(biome_data, "snow")])
			#Mountains
			elif  alt>= 0.7 and alt <= 0.9:
				biome[pos] = "mountain"
				set_cell(Vector2i(x, y), 0,
				tiles[random_tile(biome_data, "mountain")])
			#Snow
			else:
				biome[pos] = "snow"
				set_cell(Vector2i(x, y), 0,
				tiles[random_tile(biome_data, "snow")])


func save_seed(seed: int):
	var save_data = {
		"Seed": seed
	}
	var json_string = JSON.stringify(save_data)
	var file = FileAccess.open(SAVE_SEED, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
	else:
		print("Error opening file to save data")
