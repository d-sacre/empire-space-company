extends MarginContainer

@onready var _timeValue : RichTextLabel = $PanelContainer/HBoxContainer/MarginContainer/GridContainer/value

func _update_time(time : float) -> void:
	self._timeValue.text = "[center]"+ "%0.0f" % time +" s[/center]"
	
func update(time : float) -> void:
	self._update_time(time)
