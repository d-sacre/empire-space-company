extends Node2D

@export_category("Tile Map")
@export_range(0,99) var tilemapWidth : int = 20
@export_range(0,99) var tilemapHeight : int = 10

@export_category("Mineral Abundance Weighting")
@export_group("Sandstone")
@export_range(0, 99) var emptyProb : int = 80
@export_range(0, 99) var copperProb : int = 5
@export_range(0, 99) var pottasiumProb : int = 7
@export_range(0, 99) var caloricumProb : int = 8


# REMARK: Atlas Texture ID follows the convention column first
enum TILE_ATLAS_ID_LUT {
	SANDSTONE_EMPTY,
	SANDSTONE_CALORICUM,
	SANDSTONE_COPPER,
	SANDSTONE_POTTASIUM
}

@onready var tilemap : TileMapLayer = $TileMap

func convert_rnd_int_to_tile_atlas_id(rndNr : int) -> int:
	if rndNr < self.emptyProb:
		return self.TILE_ATLAS_ID_LUT.SANDSTONE_EMPTY
	elif rndNr < self.emptyProb + self.copperProb:
		return self.TILE_ATLAS_ID_LUT.SANDSTONE_COPPER
	elif rndNr < self.emptyProb + self.copperProb + self.pottasiumProb:
		return self.TILE_ATLAS_ID_LUT.SANDSTONE_POTTASIUM
	elif rndNr < self.emptyProb + self.copperProb + self.pottasiumProb + self.caloricumProb:
		return self.TILE_ATLAS_ID_LUT.SANDSTONE_CALORICUM
	else:
		return 0

func create_tilemap() -> void:
	var _sum : float = self.emptyProb + self.copperProb + self.pottasiumProb + self.caloricumProb

	for x in range(0, self.tilemapWidth):
		for y in range(0, self.tilemapHeight):
			#var tilePosition := tilemap.local_to_map(Vector2i(randi(),randi()))
			@warning_ignore("narrowing_conversion")
			var _randomNumber : int = randi_range(0, _sum) 

			var _tileAtlasID : int = convert_rnd_int_to_tile_atlas_id(_randomNumber)
			var _tileSetSourceElement = self.tilemap.tile_set.get_source(0).get_tile_id(_tileAtlasID)
		
			@warning_ignore("integer_division")
			var _tilePosition : Vector2i = Vector2i(x, y)

			self.tilemap.set_cell(_tilePosition, 0, _tileSetSourceElement)

func _on_reload_button_pressed() -> void:
	create_tilemap()

func _ready() -> void:
	# var numberElements = tilemap.tile_set.get_source(0).get_tiles_count()
	create_tilemap()
	
