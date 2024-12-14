extends Node2D

@onready var gameDataManager : Node = $gameDataManager
@onready var inventory : Node = $gameDataManager/inventory
@onready var world : Node2D = $world



@onready var hud : MarginContainer = $UI/Control/hud
@onready var debugInventory : Control = $UI/Control/HBoxContainer/DEBUG_INVENTORY


func _ready() -> void:
	self.inventory.initialize([world.get_node("drill")])

func _process(delta: float) -> void:
	self.gameDataManager.update_time(delta)

	self.debugInventory.update(self.gameDataManager.get_inventory())
	self.hud.update(self.gameDataManager.get_database_complete())
