extends Node

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
		"max": 5.00 # REMARK: Has to be made flexible
	}
}

@onready var _inventory : Node = $inventory

func _update_energy() -> void:
	self._database.energy.current = self._inventory._inventory.energy.current.value

func _update_decarbonize_max() -> void:
	self._database.decarbonize.max = self._inventory._inventory.decarbonizer.value

func _update_weight() -> void:
	# REMARK: Rocket empty weight hardcoded!
	self._database.weight.current = 100.00 + self._inventory.get_weight()

func update_time(timeDelta : float) -> void:
	self._database.time.current += timeDelta

func get_database_complete() -> Dictionary:
	var _tmp_complete : Dictionary = {"inventory": self._inventory.get_inventory()}
	_tmp_complete.merge(self._database)

	return _tmp_complete

func get_inventory() -> Dictionary:
	return self._inventory.get_inventory()

func _process(_delta: float) -> void:
	self._update_energy()
	self._update_decarbonize_max()
	self._update_weight()
