@tool
extends MarginContainer

@export_category("Inventory Item")
@export var _itemName : String = "Item Name" 

@export_file var _iconPath = "res://icon.svg"
@export var _iconSize : Vector2 = Vector2(128,128)
@export var _itemValue : float = 0.00
@export_enum("t", "kg", "J") var _itemUnit : String = "t"

@onready var _icon : TextureRect = $GridContainer/CenterContainer/TextureRect
@onready var _label : Label = $GridContainer/Label
@onready var _quantity : RichTextLabel = $GridContainer/RichTextLabel

func _update_icon() -> void:
	self._icon.set_texture(load(self._iconPath))
	
func _update_item_name() -> void:
	self._label.text = self._itemName

func _update_quantity() -> void:
	self._quantity.text = "[center]" + "%0.2f" % self._itemValue + " " + self._itemUnit + "[/center]"

func initialize() -> void:
	self._update_icon()
	self._update_item_name()
	self._update_quantity()


func update_value(value : float) -> void:
	self._itemValue = value
	self._update_quantity()

func _ready() -> void:
	self.initialize()
	
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		self.initialize()
