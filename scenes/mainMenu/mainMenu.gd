extends Control

const _buttonPathRoot : String = "MarginContainer/VBoxContainer/"

@onready var _buttonReferences : Dictionary = {
	"play": self.get_node(self._buttonPathRoot + "play"),
	"credits": self.get_node(self._buttonPathRoot + "credits"),
	"exit": self.get_node(self._buttonPathRoot + "exit")
}

@onready var _credits : RichTextLabel = $credits

var _bbcodeparser = dictionaryToBBCodeParser.new()

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
	
func _on_credits_button_pressed() -> void:
	self._credits.visible = !self._credits.visible
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _ready() -> void:
	self._buttonReferences.play.connect("pressed", _on_play_button_pressed)
	self._buttonReferences.credits.connect("pressed", _on_credits_button_pressed)
	
	if OS.has_feature("web"):
		self._buttonReferences.exit.visible = false
	else:
		self._buttonReferences.exit.connect("pressed", _on_exit_button_pressed)
		
	var _creditsTextAsDict = JsonFio.load_json("res://assets/text/credits/credits.json")
	self._credits.text = _bbcodeparser.parse_dictionary_to_bbcode(_creditsTextAsDict)
	self._credits.visible = false
