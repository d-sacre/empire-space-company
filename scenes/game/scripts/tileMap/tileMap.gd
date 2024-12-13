extends TileMapLayer

func local_to_map_corrected(positionScreenspace : Vector2) -> Vector2i:
	var positionToMap : Vector2 =  (positionScreenspace - self.position) * 1/self.scale 
	var tileCoordinate : Vector2i = self.local_to_map(positionToMap)
	
	return tileCoordinate


func map_to_local_corrected(tileCoordinate: Vector2i) -> Vector2:
	# var gridSize : Vector2i = self.tile_set.tile_size

	var tcLocalSpaceCorrected : Vector2 = Vector2(0,0)

	# DESCRIPTION: Convert tile coordinate to local coordinate and apply tile map scaling
	var tcLocalSpaceScaled = self.map_to_local(tileCoordinate) * self.scale
	
	# DESCRIPTION: Correct the offset because of the selected tile and the offset of the complete tile map
	# REMARK: Component wise multiplication of gridSize and tileCoordinate required due to
	# data type incompatibility (Vector2i vs. Vector2)
	var tcLSGridCorrected = tcLocalSpaceScaled #- Vector2(gridSize.x * tileCoordinate.x, gridSize.y * tileCoordinate.y) * self.scale
	tcLocalSpaceCorrected = tcLSGridCorrected + self.position

	return tcLocalSpaceCorrected

func fillTileMap(tileDB : Dictionary, width : int, height : int, tileMap = self) -> void:
	var source : TileSetSource = tileMap.tile_set.get_source(0)
	var sum : int = 0
	var elements : Array[Array] = []
	
	for i in range(0, source.get_tiles_count()):
		tileMap.set_cell(Vector2i(0,0), 0, source.get_tile_id(i))
		var data : TileData = tileMap.get_cell_tile_data(Vector2i(0,0))
		var tileName : String = data.get_custom_data("ORE_TYPE")
		if tileDB.has(tileName):
			sum += tileDB[tileName]
			elements.append([sum, i])
			
	for x in range(-floor(width/2), floor(width/2)+1):
		for y in range(0, height):
			var randomNumber : int = randi_range(0, sum-1)
			for e in elements:
				if randomNumber < e[0]:
					tileMap.set_cell(Vector2i(x,y), 0, source.get_tile_id(e[1]))
					break
