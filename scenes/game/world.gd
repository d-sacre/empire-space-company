extends Node2D

@export_category("Tile Map")
@export_range(0,99) var _tilemapWidth : int = 21
@export_range(0,99) var _tilemapHeight : int = 10
@export_range(0,1.0) var _tilemapScale : float = 0.125 # old: 0.175, calculated: 0.121

@export_category("Mineral Abundance Weighting")
@export var includedTiles : Dictionary = {"copper" : 5, "empty" : 80, "potassium" : 7, "caloricum" : 8}

@onready var _tilemap : TileMapLayer = $TileMap
@onready var _drill : Node2D = $drill

var _error : int = 0

func initialize() -> void:
	self._tilemap.scale = Vector2(self._tilemapScale, self._tilemapScale)
	self._tilemap.fillTileMap(includedTiles, _tilemapWidth, _tilemapHeight)
	self._error = self._drill.initialize(self._tilemap, self._tilemapWidth, self._tilemapHeight, self._tilemap.scale)

# REMARK: Reload does currently not reconfigure the drill correctly
func _on_reload_button_pressed() -> void:
	self._tilemap.clear()
	self._error = self._drill.initialize(self._tilemap, self._tilemapWidth, self._tilemapHeight, self._tilemap.scale)
	self.initialize()

func _ready() -> void:
	self.initialize()

# REMARK: Necessary to prevent double interaction whilst clicking on a button
func _unhandled_input(event) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("LMB"):
			self._drill.new_target_selected()

	if event is InputEventMouseMotion:
		self._drill.update_future_route(self.get_global_mouse_position())
		
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Toggle Fullscreen"):
		var _tmp_currentWindowStatus = DisplayServer.window_get_mode()
		var _tmp_newWindowStatus = _tmp_currentWindowStatus
		
		match _tmp_currentWindowStatus:
			DisplayServer.WINDOW_MODE_FULLSCREEN:
				_tmp_newWindowStatus = DisplayServer.WINDOW_MODE_WINDOWED
			DisplayServer.WINDOW_MODE_WINDOWED:
				_tmp_newWindowStatus = DisplayServer.WINDOW_MODE_FULLSCREEN
			DisplayServer.WINDOW_MODE_MAXIMIZED:
				_tmp_newWindowStatus = DisplayServer.WINDOW_MODE_FULLSCREEN
			
		DisplayServer.window_set_mode(_tmp_newWindowStatus) 
