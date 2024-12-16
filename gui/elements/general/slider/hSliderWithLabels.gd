@tool

extends MarginContainer

signal slider_value_changed(sliderID, value)

@export_category("Slider with Labels")
@export var _sliderID : String = "Slider ID"
@export var _descriptor : String = "Descriptor" 
@export var _currentValue : float = 0.00
@export var _startValue : float = 0.00
@export var _minimum : float = 0.00
@export var _maximum : float = 0.00
@export var _step : float = 0.01
@export_flags("true") var _sliderDisabled : int
@export_enum("%0.2f", "%0.1f", "%0.0f") var _decimalHandling : String = "%0.2f"
@export_enum("t", "kg", "J", "%", "NONE") var _itemUnit : String = "t"
@export_flags("true") var _showMax : int

var _itemUnitBBCode : String = ""

@onready var _description : RichTextLabel = $CenterContainer/GridContainer/description
@onready var _slider : HSlider = $CenterContainer/GridContainer/HSlider
@onready var _valueLabel : RichTextLabel = $CenterContainer/GridContainer/value

func _update_descriptor() -> void:
	self._description.text = self._descriptor

func _update_quantity() -> void:
	var _tmp_text : String = "[center]" + self._decimalHandling % self._currentValue + self._itemUnitBBCode
	
	if self._showMax == 1:
		_tmp_text += "/" + self._decimalHandling % self._maximum + self._itemUnitBBCode
	self._valueLabel.text =  _tmp_text + "[/center]"
	
func _update_disable_slider() -> void:
	var _tmp_editable : bool = true
	
	if self._sliderDisabled == 1:
		_tmp_editable = false
	
	self._slider.editable = _tmp_editable
	
func _update_slider_limits() -> void:
	self._slider.step = self._step
	self._slider.min_value = self._minimum
	self._slider.max_value = self._maximum
	
func _update_slider() -> void:
	self._update_slider_limits()
	self._slider.value = self._currentValue
	slider_value_changed.emit(self._sliderID, self._currentValue)

func _initialize() -> void:
	if self._itemUnit != "NONE":
		self._itemUnitBBCode = " " + self._itemUnit
	
	self._update_descriptor()
	self._update_slider()
	self._slider.value = self._startValue
	self._update_disable_slider()
	self._update_quantity()
	
func set_slider_max(value : float) -> void:
	self._maximum = value
	self._update_slider_limits()
	
func set_slider_status(disabled : bool) -> void:
	if not disabled:
		self._sliderDisabled = 0
	else:
		self._sliderDisabled = 1
		
	self._update_disable_slider()

func get_slider_reference() -> HSlider:
	return self._slider

func force_set_slider_value(value : float) -> void:
	self._slider.value = value
	slider_value_changed.emit(self._sliderID, self._currentValue)

func _on_h_slider_value_changed(value: float) -> void:
	self._currentValue = value
	slider_value_changed.emit(self._sliderID, self._currentValue)
	self._update_quantity()
	
func _ready() -> void:
	self._initialize()
	
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		self._initialize()
