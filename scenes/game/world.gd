extends Node2D

@export_category("Tile Map")
@export_range(0,99) var _tilemapWidth : int = 20
@export_range(0,99) var _tilemapHeight : int = 10

@export_category("Mineral Abundance Weighting")
@export var includedTiles : Dictionary = {"copper" : 5, "empty" : 80, "pottasium" : 7, "caloricum" : 8}

@onready var _tilemap : TileMapLayer = $TileMap

func fillTileMap(width : int, height : int) -> void:
	var source : TileSetSource = self._tilemap.tile_set.get_source(0)
	var sum : int = 0
	var elements : Array[Array] = []
	
	for i in range(0, source.get_tiles_count()):
		self._tilemap.set_cell(Vector2i(0,0), 0, source.get_tile_id(i))
		var data : TileData = self._tilemap.get_cell_tile_data(Vector2i(0,0))
		var tileName : String = data.get_custom_data("Name")
		if includedTiles.has(tileName):
			sum += includedTiles[tileName]
			elements.append([sum, i])
			
	for x in range(0, width):
		for y in range(0, height):
			var randomNumber : int = randi_range(0, sum)
			for e in elements:
				if randomNumber < e[0]:
					self._tilemap.set_cell(Vector2i(x,y), 0, source.get_tile_id(e[1]))
					break

func _on_reload_button_pressed() -> void:
	fillTileMap(_tilemapWidth,_tilemapHeight)

func _ready() -> void:
	fillTileMap(_tilemapWidth,_tilemapHeight)
