extends MarginContainer

const _inventoryItemsRoot : String = "PanelContainer/VBoxContainer/CenterContainer/GridContainer/"

@onready var _inventoryElements : Dictionary = {
	"ore": {
		"caloricum": self.get_node(self._inventoryItemsRoot + "caloricumOre"),
		"potassium": self.get_node(self._inventoryItemsRoot + "potassiumOre"),
		"copper": self.get_node(self._inventoryItemsRoot + "copperOre")
	},
	"energy": self.get_node(self._inventoryItemsRoot + "energy"),
	"decarbonizer": self.get_node(self._inventoryItemsRoot + "decarbonizer")
}

func update(inventoryDB : Dictionary) -> void:
	for oreType in ["caloricum", "potassium", "copper"]:
		self._inventoryElements["ore"][oreType].update_value(
			inventoryDB["ore"][oreType]["value"]
		)

	self._inventoryElements.energy.update_value(inventoryDB["energy"]["current"]["value"])
	self._inventoryElements.decarbonizer.update_value(inventoryDB["decarbonizer"]["value"])
