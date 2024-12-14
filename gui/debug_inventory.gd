extends MarginContainer

const _inventoryItemsRoot : String = "PanelContainer/VBoxContainer/CenterContainer/GridContainer/"

@onready var _inventoryElements : Dictionary = {
	"ore": {
		"caloricum": self.get_node(self._inventoryItemsRoot + "caloricumOre"),
		"potassium": self.get_node(self._inventoryItemsRoot + "potassiumOre"),
		"copper": self.get_node(self._inventoryItemsRoot + "copperOre")
	}
}

func update_inventory(inventoryDB : Dictionary) -> void:
	for oreType in ["caloricum", "potassium", "copper"]:
		self._inventoryElements["ore"][oreType].update_value(
			inventoryDB["ore"][oreType]["value"]
		)
