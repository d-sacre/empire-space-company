extends Path2D

const SPEED = 100

var _tileMap : Dictionary = {
	"width" = 0,
	"height" = 0,
	"scale" = Vector2(1,1),
	"reference" = null
}

var _futureRoute : Dictionary = {
	"START_POINT": {
		"TMC": Vector2i(0,0),
		"LOCAL": Vector2(0,0)
	},
	"END_POINT": {
		"TMC": Vector2i(0,0),
		"LOCAL": Vector2(0,0)
	},
	"TMC": [],
	"LOCAL": {
		"DRAW": [],
		"PATH": []
	}
}

var _currentRoute : Dictionary = {
	"START_POINT": {
		"TMC": Vector2i(0,0),
		"LOCAL": Vector2(0,0)
	},
	"END_POINT": {
		"TMC": Vector2i(0,0),
		"LOCAL": Vector2(0,0)
	},
	"TMC": [],
	"LOCAL": {
		"DRAW": [],
		"PATH": []
	}
}

var _initialTile : Vector2i = Vector2i(0,0)
var _initialPosition : Dictionary = {
	"path": Vector2(0,0),
	"sprite": Vector2(0,0)
}
var _inInitialState : bool = true

var _machineSpeed : float = 1.0

var _routeLocked : bool = false
var _enRoute : bool = false

var _error : int = 0

@onready var _sprite : Sprite2D = $PathFollow2D/Sprite2D
@onready var _pathFollow : PathFollow2D = $PathFollow2D

func get_drill_size() -> Vector2:
	return Vector2(
		self._sprite.texture.get_width(), 
		self._sprite.texture.get_height()
	)

func get_drill_scale() -> Vector2:
	return self._sprite.scale

func set_drill_scale(_scale : Vector2) -> void:
	self._sprite.scale = _scale

func calculate_drill_position_path(tileCoordinate : Vector2i) -> Vector2:
	return self._tileMap.reference.map_to_local_corrected(tileCoordinate)# + Vector2(0,-self.get_drill_size().y) * self.get_drill_scale() #+ Vector2(0,-self.get_drill_size().y/2) * self.get_drill_scale() + Vector2(0,-self._tileMap.reference.tile_set.tile_size.y/2)* self._tileMap.reference.scale

func calculate_drill_position_sprite(tileCoordinate : Vector2i) -> Vector2:
	# self._tileMap.reference.map_to_local_corrected(tileCoordinate) +
	return  Vector2(0,-self.get_drill_size().y/2) * self.get_drill_scale() + Vector2(0,-self._tileMap.reference.tile_set.tile_size.y/2)* self._tileMap.reference.scale

func _convert_route_to_drill_path_local(tileCoordinate : Vector2i) -> Vector2:
	return self._tileMap.reference.map_to_local_corrected(tileCoordinate) - self._tileMap.reference.position + Vector2(-self._tileMap.reference.tile_set.tile_size.x/2, -self._tileMap.reference.tile_set.tile_size.y/2) * self._tileMap.reference.scale

func get_drill_position_local() -> Vector2:
	return self._sprite.position

func _clear_future_route_waypoints() -> void:
	self._futureRoute.TMC = []
	self._futureRoute.LOCAL.DRAW = PackedVector2Array()
	self._futureRoute.LOCAL.PATH = PackedVector2Array()

## initializes the drill with all the relevant [TileMapLayer] data[br]
## **REMARK:** [br]
## Variable `_scale` had to be used to prevent[br]
## `The local function Parameter "scale" is shadowing an already-declared of the base class at "Node2D"`
func initialize(tilemapReference : TileMapLayer, width : int, height : int, _scale : Vector2) -> int:
	# DESCRIPTION: Setting the local member variables
	self._tileMap.width = width
	self._tileMap.height = height
	self._tileMap.scale = _scale
	self._tileMap.reference = tilemapReference

	# DESCRIPTION: Calculating the starting Tile Map Coordinates, convert them to Local Coordinates and 
	# translate the drill above it
	# REMARK: If Tile Map is not centered, this does not work
	# @warning_ignore("integer_division")
	# self._initialTile = Vector2i(0,0)# Vector2i(floor(self._tileMap.width/2) + self._tileMap.width % 2, 0)

	# DESCRIPTION: Scale the Sprite according to the Tile Map so that it (visually) fits
	self.set_drill_scale(4 * self._tileMap.scale)

	self.position = self.calculate_drill_position_path(self._initialTile)
	self._initialPosition.path = self.position

	self._sprite.position = self.calculate_drill_position_sprite(self._initialTile)
	self._initialPosition.sprite = self._sprite.position

	print_debug(self._initialPosition.path)

	self._futureRoute.START_POINT.TMC = self._initialTile

	self._pathFollow.progress_ratio = 0.0
	self.set_curve(Curve2D.new())

	return 0

## **REMARK**: `endPoint` has to be provided in Screenspace Coordinates**
func update_future_route(endPoint : Vector2) -> void:
	if not self._routeLocked:
		var _tmp_tileCoordinateStart : Vector2i = self._futureRoute.START_POINT.TMC
		var _tmp_tileCoordinateEnd : Vector2i = self._tileMap.reference.local_to_map_corrected(endPoint)

		# DESCRIPTION: Only create new route when y coordinate of end point is below the surface
		# REMARK: Follows from the shift of the Tile Map and has to be considered as hardcoded magic number!
		if _tmp_tileCoordinateEnd.y >= 0:
			if _tmp_tileCoordinateStart.y >= 0:
				self._futureRoute.START_POINT.TMC = _tmp_tileCoordinateStart
				self._futureRoute.END_POINT.LOCAL = endPoint
				self._futureRoute.END_POINT.TMC = _tmp_tileCoordinateEnd

				var _tmp_futureRouteTMC : Array[Vector2i] = [_tmp_tileCoordinateStart]

				# DESCRIPTION: Calculate intermediate points and decide, whether they are separated by a
				# large enough distance to be both included into the path
				# REMARK: Only holds true for centered Tile Maps; otherwise self._initialTile has to be used
				var _tmp_intermediate1 : Vector2i = Vector2i(0, _tmp_tileCoordinateStart.y)
				var _tmp_intermediate2 : Vector2i = Vector2i(0, _tmp_tileCoordinateEnd.y)

				if _tmp_intermediate1 not in _tmp_futureRouteTMC:
					_tmp_futureRouteTMC.append(_tmp_intermediate1)

				if _tmp_intermediate1 != _tmp_intermediate2:
					if _tmp_intermediate2 not in _tmp_futureRouteTMC:
						if _tmp_intermediate2 != _tmp_tileCoordinateEnd:
							_tmp_futureRouteTMC.append(_tmp_intermediate2)

				_tmp_futureRouteTMC.append(_tmp_tileCoordinateEnd)

				self._futureRoute.TMC = _tmp_futureRouteTMC

				# DESCRIPTION: Convert Tile Map Coordinates to Local Space
				var _tmp_futureRouteLSDRAW : PackedVector2Array = PackedVector2Array()

				for i in range(len(_tmp_futureRouteTMC)):
					var _tmp_localCoord = self._convert_route_to_drill_path_local(_tmp_futureRouteTMC[i])
					_tmp_futureRouteLSDRAW.append(_tmp_localCoord)

				self._futureRoute.LOCAL.DRAW = _tmp_futureRouteLSDRAW
				# REMARK: Only temporary, until sprite offset is correctly implemented
				self._futureRoute.LOCAL.PATH = _tmp_futureRouteLSDRAW 

				if self._inInitialState:
					self._futureRoute.LOCAL.PATH[0] += self.calculate_drill_position_sprite(_tmp_tileCoordinateStart)
			
			else:
				self._clear_future_route_waypoints()
		else:
			self._clear_future_route_waypoints()

func new_target_selected() -> void:
	self._routeLocked = true
	print_debug("New Target selected!")


	self._currentRoute = self._futureRoute
	self._futureRoute.START_POINT.TMC = self._currentRoute.END_POINT.TMC

	var _tmp_curve : Curve2D = Curve2D.new()

	for _waypoint in self._currentRoute.LOCAL.PATH:
		_tmp_curve.add_point(_waypoint)

	self.set_curve(_tmp_curve)
	self._pathFollow.progress_ratio = 0.0

	# DESCRIPTION: Handle the Initial Drill State
	# REMARK: Sprite in Initial Drill State has to be offset from the origin of the Path
	# During the path following, this offset would cause problems, so it has to be removed prior
	if self._inInitialState:
		self._sprite.position = Vector2(0,0)
		self._inInitialState = false

	self._enRoute = true

func _ready() -> void:
	pass

func _draw() -> void:
	if self._futureRoute != {}:
		if len(self._futureRoute.LOCAL.DRAW) >= 2:
			draw_polyline(self._futureRoute.LOCAL.DRAW, Color.BLUE, 20)
			draw_circle(self._futureRoute.LOCAL.DRAW[-1], 20, Color.BLUE)

func _process(delta : float) -> void:
	if not self._routeLocked:
		queue_redraw()
	else:
		if self._enRoute:
			if self._pathFollow.progress_ratio < 1.0:
				self._pathFollow.progress += self._machineSpeed * self.SPEED * delta

			else:
				self._enRoute = false
				self._routeLocked = false
				self._clear_future_route_waypoints()
			
