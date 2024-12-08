extends Node2D

@onready var tilemap : TileMapLayer = $TileMap

@export_category("Misc")
@export_range(0, 99) var emptyProb : int = 80
@export_range(0, 99) var copperProb : int = 5
@export_range(0, 99) var pottProb : int = 7
@export_range(0, 99) var colorProb : int = 8

func getTileID(rndNr : int) -> int:
	if rndNr < emptyProb:
		return 0
	elif rndNr < emptyProb + copperProb:
		return 2
	elif rndNr < emptyProb + copperProb + pottProb:
		return 3
	elif rndNr < emptyProb + copperProb + pottProb + colorProb:
		return 1
	else:
		return 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var numberElements = tilemap.tile_set.get_source(0).get_tiles_count()
	var sum : float = emptyProb + copperProb + pottProb + colorProb

	for i in range(0, 20):
		var tilePosition := tilemap.local_to_map(Vector2i(randi(),randi()))
		var randomNumber : int = randi_range(0, sum)
		var element : int = getTileID(randomNumber)
		var tileElement = tilemap.tile_set.get_source(0).get_tile_id(int(element))
	
		var pos : Vector2i = Vector2i(i % 5, i / 5)
		var tileType : Vector2i = Vector2i(0,0)
		tilemap.set_cell(pos, 0, tileElement)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
