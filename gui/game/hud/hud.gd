extends MarginContainer

var _hudItemsRoot : String = "PanelContainer/HBoxContainer/"

@onready var _hudItems: Dictionary = {
	"weight": self.get_node(self._hudItemsRoot + "weight"),
	"time": self.get_node(self._hudItemsRoot + "MarginContainer/GridContainer/value")
}

func _update_time(time : float) -> void:
	self._hudItems.time.text = "[center]"+ "%0.0f" % time +" s[/center]"
	
func update(data : Dictionary) -> void:
	for _itemKey in _hudItems.keys():
		if _itemKey != "time":
			var _tmp_dbEntry : Dictionary = data[_itemKey]
			var _tmp_value : float = _tmp_dbEntry["current"]
			var _tmp_status : String = _tmp_dbEntry["status"]

			self._hudItems[_itemKey].update_value_and_status(_tmp_value, _tmp_status)

		else:
			self._update_time(data.time.current)
