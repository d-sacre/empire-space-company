extends PanelContainer

func set_fullscreen_button(status : bool) -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/CheckButton.button_pressed = status

func _ready() -> void:
	if OS.has_feature("web"):
		$MarginContainer/VBoxContainer/exit.visible = false

func _process(_delta: float) -> void:
	#if self.visible:
	if Input.is_action_just_pressed("ui_cancel"):
		self.visible = !self.visible
		get_tree().paused = !get_tree().paused
		
		var _tmp_buttonStatus = false
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			_tmp_buttonStatus = true
			
		self.set_fullscreen_button(_tmp_buttonStatus)

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_check_button_pressed() -> void:
	WindowManager.set_window_to_fullscreen()
