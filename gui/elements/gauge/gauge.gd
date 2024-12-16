@tool

extends Control

@export_category("Rotation")
@export var pivot_point : Vector2 = Vector2(48,72)
@export var angle_min : float = -38
@export var angle_max : float = 38

@export_category("Value")
@export var minimum : float = 0.0
@export var maximum : float = 1.0
@export var current : float = 0.5 * maximum
@export_range(0.0,1.0,0.01) var current_factor : float = 0.5

var _rotation : float = 0.00

@onready var _dial : TextureRect = $dial

func _update() -> void:
	if not Engine.is_editor_hint():
		self.current_factor = abs((self.current - self.minimum)/abs(self.maximum-self.minimum))
		
	self._rotation = self.current_factor * abs(angle_max-angle_min) + angle_min
	self._dial.rotation_degrees = self._rotation
	
func update_value(value : float) -> void:
	self.current = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pivot_offset = pivot_point
	self._update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self._update()
