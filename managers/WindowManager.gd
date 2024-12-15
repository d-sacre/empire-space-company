extends Node

func set_window_to_fullscreen() -> void:
	var _tmp_currentWindowStatus = DisplayServer.window_get_mode()
	var _tmp_newWindowStatus = _tmp_currentWindowStatus

	match _tmp_currentWindowStatus:
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			_tmp_newWindowStatus = DisplayServer.WINDOW_MODE_WINDOWED
		DisplayServer.WINDOW_MODE_WINDOWED:
			_tmp_newWindowStatus = DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.WINDOW_MODE_MAXIMIZED:
			_tmp_newWindowStatus = DisplayServer.WINDOW_MODE_FULLSCREEN
		
	DisplayServer.window_set_mode(_tmp_newWindowStatus) 


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Toggle Fullscreen"):
		self.set_window_to_fullscreen()
