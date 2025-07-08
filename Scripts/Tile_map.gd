extends TileMap

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var width = 190
var height = 110
@onready var player = get_parent().get_parent().get_child(3)

# Called when the node enters the scene tree for the first time.
func _ready():
	moisture.seed = randi() # Having three randi so that they are unique
	temperature.seed = randi()
	altitude.seed = randi()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	generate_chunk(player.position)
	
func generate_chunk(position):
	var tile_pos = local_to_map(position) # gets the position in tilemap coords
	for x in range (width):
		for y in range(height):
			var moist = moisture.get_noise_2d(tile_pos.x + x - width/2, tile_pos.y + y - height/2)*10
			var temp = temperature.get_noise_2d(tile_pos.x + x - width/2, tile_pos.y + y - height/2)*10
			var alt = altitude.get_noise_2d(tile_pos.x + x - width/2, tile_pos.y + y - height/2)*10
			
			if alt < 2: #generates water is altitude is too low
				set_cell(0, Vector2i(tile_pos.x + x - width/2, tile_pos.y + y - height/2), 0, Vector2i(3,round((temp+10)/5)))
			else:
				set_cell(0, Vector2i(tile_pos.x + x - width/2, tile_pos.y + y - height/2), 0, Vector2i(round((moist+10)/5),round((temp+10)/5)))
