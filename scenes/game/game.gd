extends Node2D

@onready var inventory : Node = $inventory
@onready var world : Node2D = $world

@onready var hud : MarginContainer = $UI/Control/hud
@onready var debugInventory : Control = $UI/Control/HBoxContainer/DEBUG_INVENTORY

var _time : float = 0.00

func _ready() -> void:
	self.inventory.initialize([world.get_node("drill")])

func _process(delta: float) -> void:
	self._time += delta
	self.debugInventory.update_inventory(self.inventory.get_inventory())
	self.hud.update(self._time)
