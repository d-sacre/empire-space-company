extends Control

@onready var _inventoryElements : Dictionary = {
	"ore": {
		"caloricum": $PanelContainer/CenterContainer/GridContainer/caloricumOre,
		"potassium": $PanelContainer/CenterContainer/GridContainer/potassiumOre,
		"copper": $PanelContainer/CenterContainer/GridContainer/copperOre
	}
}

func update_inventory(inventoryDB : Dictionary) -> void:
	for oreType in ["caloricum", "potassium", "copper"]:
		self._inventoryElements["ore"][oreType].update_value(
			str(inventoryDB["ore"][oreType]["value"])
		)
