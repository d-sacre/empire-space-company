extends Node2D

@export_category("Game State Machine")
@export_enum(
	"mining", 
	"out_of_energy",
	"out_of_oxygen",
	"too_much_co2",
	"too_much_wear",
	"too_much_weight",
	"enough", 
	"prestart", "start", 
	"start_success", "start_fail"
) var _state : String = "mining"

@onready var gameDataManager : Node = $gameDataManager
# @onready var inventory : Node = $gameDataManager/inventory
@onready var world : Node2D = $world

@onready var simulation : Node = $simulation/Resources

@onready var hud : MarginContainer = $UI/Control/hud
@onready var debugInventory : Control = $UI/Control/HBoxContainer/DEBUG_INVENTORY
@onready var controlPanel : MarginContainer = $UI/Control/HBoxContainer/controlPanel

@onready var gameOver : CenterContainer = $UI/gameOver
@onready var success : CenterContainer = $UI/success

var _error : int = 0

func _game_over_running_out(state : String) -> void:
	var _tmp_reason : String = ""

	self.simulation.set_process(false)

	match state:
		"out_of_energy":
			_tmp_reason = "You ran out of Energy!"

		"out_of_oxygen":
			_tmp_reason = "You ran out of Oxygen!"

		"too_much_co2":
			_tmp_reason = "There is too much CO2!"
		
		"too_much_wear":
			_tmp_reason = "There is too much Wear!"

		"too_much_weight":
			_tmp_reason = "You exceeded the Weight Capacity!"

	self.gameOver.set_reason(_tmp_reason)
	self.gameOver.visible = true

func _enough() -> void:
	self.simulation.set_process(false)
	self.success.visible = true

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

func _on_change_game_fsm_state_request(state : String) -> void:
	self._state = state
	print_debug("State change request: ", state)

func _ready() -> void:
	# self.inventory.initialize([self.world.get_node("drill")])
	self._error = self.gameDataManager.initialize([self.controlPanel], [self.world.get_node("drill"), self.simulation], self.simulation, self.controlPanel)
	self._error = self.gameDataManager.connect("change_game_fsm_state_request", _on_change_game_fsm_state_request)

	self.gameOver.visible = false
	self.success.visible = false

func _process(delta: float) -> void:
	match self._state:
		"mining":
			self.gameDataManager.update_by_keychain_database(self._get_simulation_values())
			self.gameDataManager.update_time(delta)

			self.debugInventory.update(self.gameDataManager.get_inventory())
			self.hud.update(self.gameDataManager.get_database_complete())

		"enough":
			self._enough()

		_:
			self._game_over_running_out(self._state)
