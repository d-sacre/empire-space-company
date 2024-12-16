@tool
extends MarginContainer

@export_category("HUD Item")
@export var _itemName : String = "Item Name" 
@export var _itemValue : float = 0.00
@export var _itemMaximumValue : float = 0.00
@export_enum("t", "kg", "J", "%") var _itemUnit : String = "t"
@export_flags("true") var _showMax : int
@export_enum("normal", "caution", "danger") var _itemStatus : String = "normal"

var _colorPrefix : String = "[color=#000000]"

@onready var _name : RichTextLabel = $GridContainer/name
@onready var _quantity : RichTextLabel = $GridContainer/quantity
	
func _update_item_font_color_default() -> void:
	match self._itemStatus:
		"normal":
			self._colorPrefix = "[color=#ffffff]"
		"caution":
			self._colorPrefix = "[color=#fff300]"
		"danger":
			self._colorPrefix = "[color=#ff0000]"

func _update_item_name() -> void:
	var _tmp_text : String = "[center]" + self._colorPrefix + self._itemName + ": [/color][/center]"
	self._name.text = _tmp_text

func _update_quantity() -> void:
	var _tmp_text : String = "[center]" + self._colorPrefix + "%0.2f" % self._itemValue + " " + self._itemUnit
	if self._showMax == 1:
		_tmp_text += "/" + "%0.2f" % self._itemMaximumValue + " " + self._itemUnit
	self._quantity.text =  _tmp_text + "[/color][/center]"

func initialize() -> void:
	self._update_item_name()
	self._update_item_font_color_default()
	self._update_item_name()
	self._update_quantity()
	
func update_item_status(status : String) -> void:
	self._itemStatus = status
	self.initialize()

func update_value(value : float) -> void:
	self._itemValue = value
	self._update_quantity()

func update_value_and_status(value : float, status : String) -> void:
	if status != self._itemStatus:
		self.update_item_status(status)

	self.update_value(value)

func _ready() -> void:
	self.initialize()
	
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		self.initialize()
