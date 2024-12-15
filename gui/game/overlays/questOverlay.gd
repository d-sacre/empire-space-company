extends CenterContainer

@onready var _reason : RichTextLabel = $PanelContainer/MarginContainer/CenterContainer/VBoxContainer/reason
@onready var _mainMenuButton : Button = $PanelContainer/MarginContainer/CenterContainer/VBoxContainer/returnToMainMenu
@onready var _exitButton : Button = $PanelContainer/MarginContainer/CenterContainer/VBoxContainer/exit

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/mainMenu/mainMenu.tscn")
	
func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	self.visible = false
	
func set_reason(text : String) -> void:
	self._reason.text = "[center]" + text + "[/center]"
	
func initialize() -> void:
	self.set_reason("Mine " + str(GAME_PARAMETERS.GOALS.MINING.COPPER.ORE) + " t of Copper!")

func _ready() -> void:
	self._exitButton.connect("pressed", _on_exit_button_pressed)
	self._mainMenuButton.connect("pressed", _on_main_menu_button_pressed)
	
	self.set_reason("Mine " + str(GAME_PARAMETERS.GOALS.MINING.COPPER.ORE) + " t of Copper!")
	
	self.visible = true
	get_tree().paused = true
