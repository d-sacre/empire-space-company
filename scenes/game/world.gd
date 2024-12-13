extends Node2D

@export_category("Tile Map")
@export_range(0,99) var _tilemapWidth : int = 21
@export_range(0,99) var _tilemapHeight : int = 10

@export_category("Mineral Abundance Weighting")
@export var includedTiles : Dictionary = {"copper" : 5, "empty" : 80, "pottasium" : 7, "caloricum" : 8}

@onready var _tilemap : TileMapLayer = $TileMap
@onready var _drill : Node2D = $drill

@onready var _tileMapHighlightMaterial : ShaderMaterial = load("res://assets/2d/tiles/tileset/materials/tileMap_highlight.material") 

var _tileMapGridSize : Vector2i = Vector2i(0,0)

var _error : int = 0

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
			
	for x in range(-floor(width/2), floor(width/2)+1):
		for y in range(0, height):
			var randomNumber : int = randi_range(0, sum-1)
			for e in elements:
				if randomNumber < e[0]:
					self._tilemap.set_cell(Vector2i(x,y), 0, source.get_tile_id(e[1]))
					break

func initializeWorld() -> void:
	fillTileMap(_tilemapWidth,_tilemapHeight)
	self._error = self._drill.initialize(self._tilemap, self._tilemapWidth, self._tilemapHeight, self._tilemap.scale)
	
	var _tmp_tileSizeRaw : Vector2i = self._tilemap.tile_set.tile_size
	var _tmp_tileSizeFloat : Vector2 = Vector2(_tmp_tileSizeRaw.x, _tmp_tileSizeRaw.y) * self._tilemap.scale
	self._tileMapGridSize =  Vector2i(floor(_tmp_tileSizeFloat.x), floor(_tmp_tileSizeFloat.y))

func _on_reload_button_pressed() -> void:
	self._tilemap.clear()
	self.initializeWorld()

func _ready() -> void:
	self.initializeWorld()

# REMARK: Necessary to prevent double interaction whilst clicking on a button
func _unhandled_input(event) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("LMB"):
			self._drill.new_target_selected()

	if event is InputEventMouseMotion:
		# DESCRIPTION: Highlighting of Hover
		self._tileMapHighlightMaterial.set_shader_parameter("globalMousePosition", self.get_global_mouse_position())
		self._tileMapHighlightMaterial.set_shader_parameter("tileSize", self._tileMapGridSize)

		self._drill.update_future_route(self.get_global_mouse_position())

func _process(_delta: float) -> void:
	pass
