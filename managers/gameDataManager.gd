extends Node

var _queue : Array = []

var _database : Dictionary = {
	"energy": {
		"current": 800.00, # REMARK: Has to be made flexible
		"max": 800.00, # REMARK: Has to be made flexible
		"status": "normal"
	},
	"oxygen": {
		"min": Gas.O2.min,
		"current": Gas.O2.max,
		"max": Gas.O2.max,
		"status": "normal"
	},
	"carbondioxide": {
		"min": Gas.CO2.min,
		"current": Gas.CO2.min,
		"max": Gas.CO2.max,
		"status": "normal"
	},
	"productivity": {
		"current": 100.00,
		"max": 100.00,
		"status": "normal"
	},
	"wear": {
		"current": 0.00,
		"max": 100.00,
		"status": "normal"
	},
	"weight": {
		"current": 100.00, # REMARK: Has to be made flexible
		"max": 150.00, # REMARK: Has to be made flexible
		"status": "normal"
	},
	"time": {
		"current": 0.00
	},
	"machine_speed": {
		"current": 1.00, # REMARK: Has to be made flexible
		"max": 2.0 # REMARK: Has to be made flexible
	},
	"workers": {
		"refinery": {
			"current": 0, # REMARK: Has to be made flexible
			"max": 3 # REMARK: Has to be made flexible
		}
	},
	"rates": {
		"caloricum": 0.00, 
		"potassium": 0.00
	},
	"decarbonize": {
		"current": 0.00,
		"max": 5.00, # REMARK: Has to be made flexible
		"execute": false
	}
}

var _simulationReference : Node = null
var _controlPanelReference : MarginContainer = null

@onready var _inventory : Node = $inventory

var _error : int = 0

func _update_energy() -> void:
	self._inventory._inventory.energy.current.value = self._database.energy.current 

func _update_decarbonize_current(value : float) -> void:
	self._database.decarbonize.current = value

func _update_decarbonize_max() -> void:
	self._database.decarbonize.max = self._inventory._inventory.decarbonizer.value
	self._controlPanelReference.update_carbonizer_max(self._database.decarbonize.max)

func _update_decarbonizer_usage() -> void:
	if self._database.decarbonize.execute:
		self._simulationReference.set_and_lock_decarbonizer_usage(self._database.decarbonize.current)
		self._inventory._inventory.decarbonizer.value -= self._database.decarbonize.current
		self._update_decarbonize_max()

		# DESCRIPTION: Reset to defaults afterwards
		self._database.decarbonize.execute = false
		self._database.decarbonize.current = 0.00
		self._controlPanelReference.force_set_slider_value("decarbonizerAmount", self._database.decarbonize.current)

func _update_weight() -> void:
	# REMARK: Rocket empty weight hardcoded!
	self._database.weight.current = 100.00 + self._inventory.get_weight()

func _update_simulation_parameters() -> void:
	# DESCRIPTION: Update inventory properties
	self._simulationReference.energy_available = self._database.energy.current
	self._simulationReference.m_caloricum_available = self._inventory._inventory.ore.caloricum.value
	self._simulationReference.m_potassium_available = self._inventory._inventory.ore.potassium.value

	# DESCRIPTION: Update machine properties
	self._simulationReference.machinespeed = self._database.machine_speed.current

	# DESCRIPTION: Set workers in refinery
	self._simulationReference.workingHumans = self._database.workers.refinery.current

	# DESCRIPTION: Set Refinery Ore Processing Rate
	# REMARK: Since currently potassium is only refined into decarbonizers, use potassium rate
	self._simulationReference.ref_rate_caloricum = self._database.rates.caloricum
	# self._simulationReference.ref_rate_copper # REMARK: Not yet implemented
	self._simulationReference.ref_rate_potassium = self._database.rates.potassium
	self._simulationReference.ref_rate_decarbonizer = self._simulationReference.ref_rate_potassium

func _on_request_game_data_change(keyChain : Array, value, unit : String) -> void:
	self._queue.append({"keyChain": keyChain, "value": value, "unit": unit})

func initialize(signalSourcesGeneral : Array, signalSourcesInventory : Array, simulationReference : Node, controlPanelReference : MarginContainer) -> int:
	self._simulationReference = simulationReference
	self._controlPanelReference = controlPanelReference
	
	self._error = self._inventory.initialize(signalSourcesInventory)

	if self._error == 0:
		for i in range(len(signalSourcesGeneral)):
			var _tmp_error : int = signalSourcesGeneral[i].connect("request_game_data_change", _on_request_game_data_change)

			if _tmp_error != 0:
				self._error = -200 - i
				break
	else:
		self._error = -100 - self._error

	return self._error

func update_time(timeDelta : float) -> void:
	self._database.time.current += timeDelta

func update_by_keychain_database(data : Array) -> void:
	for _entry in data:
		DictionaryParsing.set_dict_element_via_keychain(self._database, _entry["keyChain"], _entry["value"])

func get_database_complete() -> Dictionary:
	var _tmp_complete : Dictionary = {"inventory": self._inventory.get_inventory()}
	_tmp_complete.merge(self._database)

	return _tmp_complete

func get_inventory() -> Dictionary:
	return self._inventory.get_inventory()

func _process(_delta: float) -> void:

	# DESCRIPTION: Processing of the incoming requests from the queue
	while len(self._queue) > 0:
		var _tmp_entry : Dictionary = self._queue.pop_at(0)
		DictionaryParsing.set_dict_element_via_keychain(self._database, _tmp_entry["keyChain"], _tmp_entry["value"])

	# DESCRIPTION: Updates of the values
	self._update_energy()
	self._update_decarbonizer_usage()
	self._update_decarbonize_max()
	self._update_weight()
	self._update_simulation_parameters()
