extends Node2D

@onready var gameDataManager : Node = $gameDataManager
# @onready var inventory : Node = $gameDataManager/inventory
@onready var world : Node2D = $world

@onready var simulation : Node = $simulation/Resources

@onready var hud : MarginContainer = $UI/Control/hud
@onready var debugInventory : Control = $UI/Control/HBoxContainer/DEBUG_INVENTORY
@onready var controlPanel : MarginContainer = $UI/Control/HBoxContainer/controlPanel

var _error : int = 0


# REMARK: Only temporary, until simulation is finalized
func _get_simulation_values() -> Array:
	var _tmp_db : Array = [
		{"keyChain": ["energy", "current"], "value": self.simulation.energy},
		{"keyChain": ["oxygen", "current"], "value": self.simulation.o2},
		{"keyChain": ["carbondioxide", "current"], "value": self.simulation.co2},
		{"keyChain": ["productivity", "current"], "value": self.simulation.p_ref_all},
		{"keyChain": ["wear", "current"], "value": self.simulation.wear}
	]

	return _tmp_db

func _ready() -> void:
	# self.inventory.initialize([self.world.get_node("drill")])
	self._error = self.gameDataManager.initialize([self.controlPanel], [self.world.get_node("drill"), self.simulation], self.simulation, self.controlPanel)

func _process(delta: float) -> void:
	self.gameDataManager.update_by_keychain_database(self._get_simulation_values())
	self.gameDataManager.update_time(delta)

	self.debugInventory.update(self.gameDataManager.get_inventory())
	self.hud.update(self.gameDataManager.get_database_complete())
