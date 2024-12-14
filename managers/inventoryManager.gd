extends Node

var _queue : Array = []

var _inventory : Dictionary = {
	"ore": {
		"caloricum": {
			"value": 0,
			"unit": "t"
		},
		"potassium": {
			"value": 0,
			"unit": "kg"
		},
		"copper": {
			"value": 0,
			"unit": "t"
		},
		"empty": {
			"value": 0,
			"unit": "t"
		}
	},
	"energy": {
		"current": {
			"value": 0,
			"unit": "J"
		},
		"max": {
			"value": 0,
			"unit": "J"
		}
	},
	"decarbonizer" : {
		"value": 0,
		"unit": "kg"
	}
}

func initialize(inventoryContributors : Array) -> int:
	for contributor in inventoryContributors:
		contributor.connect("request_inventory_change", _on_requested_inventory_change)

	return 0

func get_inventory() -> Dictionary:
	return self._inventory

func _on_requested_inventory_change(keyChain : Array, value, unit : String) -> void:
	self._queue.append({"keyChain": keyChain, "value": value, "unit": unit})

func _process(_delta : float) -> void:
	if len(self._queue) > 0:
		var _tmp_entry : Dictionary = self._queue.pop_at(0)

		for entryType in ["value", "unit"]:
			var _tmp_keyChain : Array = _tmp_entry["keyChain"].duplicate()
			_tmp_keyChain.append(entryType)

			var _tmp_value = _tmp_entry[entryType] 
			var _tmp_ignore : bool = false
			
			if _tmp_value is String:
				if _tmp_value != "FROM_LUT":
					_tmp_ignore = true

			if not _tmp_ignore:
				if entryType == "value":
					DictionaryParsing.add_to_dict_element_via_keychain(self._inventory, _tmp_keyChain, _tmp_value)
				else:
					DictionaryParsing.set_dict_element_via_keychain(self._inventory, _tmp_keyChain, _tmp_value)
