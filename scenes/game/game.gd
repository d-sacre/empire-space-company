extends Node2D

@onready var inventory : Node = $inventory
@onready var world : Node2D = $world
@onready var debugInventory : Control = $UI/Control/DEBUG_INVENTORY

func _ready() -> void:
	self.inventory.initialize([world.get_node("drill")])

func _process(_delta: float) -> void:
	self.debugInventory.update_inventory(self.inventory.get_inventory())
