extends Node2D

@onready var global: Node = get_node("/root/Global")
@onready var progress_bar: ProgressBar = $ProgressBar

const NEXT_SCENE: String = "res://Scenes/World.tscn"
const PROGRESS_START: int = 1
const PROGRESS_END: int = 100
const TILE_MAP_SIZE: int = 500


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ResourceLoader.load_threaded_request(NEXT_SCENE)
	global.height = TILE_MAP_SIZE
	global.width = TILE_MAP_SIZE 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var progress = []
	ResourceLoader.load_threaded_get_status(NEXT_SCENE,progress)
	progress_bar.value = progress[0] * PROGRESS_END
	if progress[0] == PROGRESS_START:
		var packed_scene = ResourceLoader.load_threaded_get(NEXT_SCENE)
		get_tree().change_scene_to_packed(packed_scene)
