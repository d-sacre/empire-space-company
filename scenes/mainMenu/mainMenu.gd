extends Control

const _buttonPathRoot : String = "MarginContainer/VBoxContainer/"
@onready var _buttonReferences : Dictionary = {
	"play": self.get_node(self._buttonPathRoot + "play"),
	"exit": self.get_node(self._buttonPathRoot + "exit")
}

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _ready() -> void:
	self._buttonReferences.play.connect("pressed", _on_play_button_pressed)
	
	if OS.has_feature("web"):
		self._buttonReferences.exit.visible = false
	else:
		self._buttonReferences.exit.connect("pressed", _on_exit_button_pressed)
