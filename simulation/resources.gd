extends Node

signal request_inventory_change(keyChain, value, unit)

@export_category("Simulation")
@export_group("Environment")
@export_range(Gas.O2.min, Gas.O2.max, 0.01, "suffix:%") var o2 : float = GAME_PARAMETERS.START.ATMOSPHERE.O2
@export_range(Gas.CO2.min, Gas.CO2.max, 0.01, "suffix:%") var co2 : float = GAME_PARAMETERS.START.ATMOSPHERE.CO2
@export_group("Resources")
@export_range(0.0, 99.9, 0.01, "suffix:t copper ore") var copperOre : float = 0.0
@export_range(0.0, 99.9, 0.01, "suffix:t caloricum ore") var caloricumOre : float = 0.0
@export_range(0.0, 99.9, 0.01, "suffix:kg pottasium ore") var pottasiumOre : float = 0.0
@export_range(0.0, 1500.0, 0.01, "suffix:J energy") var energy : float = GAME_PARAMETERS.START.ENERGY
@export_range(0.0, 99.9, 0.01, "suffix:t copper") var copper : float = 0.0
@export_range(0.0, 99.9, 0.01, "suffix:kg decarbonizer") var decarbonizer : float = 0.0
@export_group("Machine")
@export_range(0.0, 2.0, 0.5) var machinespeed : float = 1.0
@export_range(0.0, 1.0, 0.01) var drillspeed : float = 0.0
@export_range(0.0, 1.0, 0.01) var trainspeed : float = 0.0
@export_range(0.0, 1.0, 0.01) var liftspeed : float = 0.0
@export_range(0.0, 1.0, 0.01) var p_ref_all : float = 1.0
@export_range(0.0, 1.0, 0.01) var wear : float = GAME_PARAMETERS.START.WEAR
@export_group("Worker")
@export_range(0, 9) var maxHumans : int = 0
@export_range(0, 9) var workingHumans : int = 0
@export_range(0, 9) var maxRobots : int = 0
@export_range(0, 9) var workingRobots : int = 0

var simulationStep : float = 1.00
var _currentTime : float = 0.00

var maxWorkers : int = maxHumans + maxRobots
var workingWorkers : int = workingHumans + workingRobots
var usedDecarbonizer : float = 0.0
var massTrain : float = 0.0
var massLift : float = 0.0
var ref_rate_caloricum : float = 0.0
var ref_rate_copper : float = 0.0
var ref_rate_potassium : float = 0.0
var ref_rate_decarbonizer : float = 0.0

var energy_available : float = 0.0
var m_caloricum_available : float = 0.0
var m_potassium_available : float = 0.0

var _decarbUsageValueLocked : bool = false

func _update_working_workers() -> void:
	self.workingWorkers = workingHumans + workingRobots

func CalcFco2() -> float:
	var values : Vector2 = Gas.CO2.Values(co2)
	var factors : Vector2 = Gas.CO2.Factors(co2)
	
	return factors[0] - (factors[0] - factors[1]) / (values[1] - values[0]) * (co2 - values[0])

func CalcCco2Reduction(decarb : float = 0.00) -> float:
	return maxf(Gas.CO2.min, co2 - Ore.Decarbonizer.CO2Reduction * decarb)

func Simulate() -> void:
	var idleHumans : int = maxHumans - workingHumans
	var idleRobots : int = maxRobots - workingRobots

	self._update_working_workers()
	
	var fo2 : float = (Gas.O2.maxFactor - Gas.O2.minFactor) / (Gas.O2.max - Gas.O2.min) * o2
	var fco2 : float = self.CalcFco2()
	
	var p_ref_factor : float = 0.0
	
	if workingWorkers > 0:
		p_ref_factor = (1.0 - wear) * machinespeed / workingWorkers
	else:
		p_ref_factor = 0

	p_ref_all = p_ref_factor * (fo2 * fco2 * workingHumans + (1 - wear) * workingRobots)
	
	if self._decarbUsageValueLocked:
		co2 = self.CalcCco2Reduction(usedDecarbonizer)#maxf(Gas.CO2.min, co2 - Ore.Decarbonizer.CO2Reduction * usedDecarbonizer)
		usedDecarbonizer = 0.0
		self._decarbUsageValueLocked = false
	else:
		co2 = self.CalcCco2Reduction()
	co2 = idleHumans * Worker.Human.IdleCO2 + workingHumans * Worker.Human.WorkingCO2 + co2
	o2 = o2 - (Worker.Human.IdleOxygen * idleHumans + Worker.Human.WorkingOxygen * workingHumans)
	
	var e_workers : float = idleHumans * Worker.Human.IdleEnergy + workingHumans * Worker.Human.WorkingEnergy + idleRobots * Worker.Robot.IdleEnergy + workingRobots * Worker.Robot.WorkingEnergy
	var e_drill : float = Machine.Drill.EnergyUsage / (1 - wear) * (drillspeed * machinespeed)**2
	var e_train : float = Machine.Train.EnergyUsage * massTrain / (1 - wear) * (trainspeed * machinespeed)**2
	var e_lift : float = Machine.Lift.EnergyUsage * massLift / (1 - wear) * (liftspeed * machinespeed)**2
	var e_ref_ore : float = ref_rate_caloricum * Ore.Caloricum.EnergyReq + ref_rate_potassium * Ore.Potassium.EnergyReq
	var e_ref_usage : float = p_ref_all * workingWorkers * e_ref_ore
	var e_ref_gen : float = p_ref_all * workingWorkers * ref_rate_caloricum * Ore.Caloricum.EnergyRate
	
	wear = wear + Machine.WearFactor * machinespeed**2
	
	var m_caloricum : float = Ore.Caloricum.ProcessRate * p_ref_all * workingWorkers * ref_rate_caloricum
	var m_potassium : float = Ore.Potassium.ProcessRate * p_ref_all * workingWorkers * ref_rate_potassium
	var m_decarb : float = Ore.Potassium.RefiningRate * p_ref_all * workingWorkers * ref_rate_decarbonizer

	# DESCRIPTION: Prevent refinery from using resources that are not available
	if (m_caloricum > m_caloricum_available) or (m_caloricum < 0):
		m_caloricum = m_caloricum_available
		e_ref_gen = m_caloricum_available * Ore.Caloricum.EnergyRate
		print_debug("Less caloricum available than needed: ", m_caloricum,"/", m_caloricum_available)

	if (m_potassium > m_potassium_available) or (m_potassium < 0):
		m_potassium = m_potassium_available
		m_decarb = Ore.Potassium.RefiningRate * m_potassium

	energy = energy_available - e_workers - e_drill - e_train - e_lift - e_ref_usage + e_ref_gen
	
	
	# DESCRIPTION: Notify inventory of changes
	var _tmp_format_string = "caloricum (used/available): %s/%s, potassium (used/available): %s/%s, decarb: %s"
	var _tmp_string = _tmp_format_string % [m_caloricum, m_caloricum_available, m_potassium, m_potassium_available, m_decarb]
	print_debug(_tmp_string)
	
	request_inventory_change.emit(["ore", "caloricum"], -m_caloricum, "FROM_LUT")
	request_inventory_change.emit(["ore", "potassium"], -m_potassium, "FROM_LUT")
	request_inventory_change.emit(["decarbonizer"], m_decarb, "FROM_LUT")
	

func set_and_lock_decarbonizer_usage(value : float) -> void:
	self._decarbUsageValueLocked = true
	self.usedDecarbonizer = value


func _process(_delta : float) -> void:
	self._currentTime += _delta

	if self._currentTime >= self.simulationStep:
		self.Simulate()
		self._currentTime = 0
	pass
