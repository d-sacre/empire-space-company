extends CenterContainer

@onready var _reason : RichTextLabel = $success/MarginContainer/CenterContainer/VBoxContainer/reason
@onready var _mainMenuButton : Button = $success/MarginContainer/CenterContainer/VBoxContainer/returnToMainMenu
@onready var _exitButton : Button = $success/MarginContainer/CenterContainer/VBoxContainer/exit

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainMenu/mainMenu.tscn")
	
func _on_exit_button_pressed() -> void:
	self.get_tree().quit()
	
func set_reason(text : String) -> void:
	self._reason.text = "[center]" + text + "[/center]"

func _ready() -> void:
	if OS.has_feature("web"):
		self._exitButton.visible = false
	else:
		self._exitButton.connect("pressed", _on_exit_button_pressed)
	
	self._mainMenuButton.connect("pressed", _on_main_menu_button_pressed)