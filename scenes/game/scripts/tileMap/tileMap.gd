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
