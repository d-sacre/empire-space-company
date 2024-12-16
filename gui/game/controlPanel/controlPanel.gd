extends MarginContainer

signal request_game_data_change(keyChain, value, unit)

const CONTROL_PANEL : Dictionary = {
    "INPUT_ELEMENTS_ROOT" : "PanelContainer/VBoxContainer/",
    "INPUT_LUT": {
        "machineSpeed": {"keyChain": ["machine_speed", "current"]},
        "workersRefinery": {"keyChain": ["workers", "refinery", "current"]},
        "caloricumRate": {"keyChain": ["rates", "caloricum"]},
        "potassiumRate": {"keyChain": ["rates", "potassium"]},
        "decarbonizerAmount": {"keyChain": ["decarbonize", "current"]},
        "useDecarbonizer": {"keyChain": ["decarbonize", "execute"]}
    }
}

@onready var _uiInputElements : Dictionary = {
    "machineSpeed": self.get_node(self.CONTROL_PANEL.INPUT_ELEMENTS_ROOT + "machineSpeed"),
    "workersRefinery": self.get_node(self.CONTROL_PANEL.INPUT_ELEMENTS_ROOT + "workersRefinery"),
    "caloricumRate": self.get_node(self.CONTROL_PANEL.INPUT_ELEMENTS_ROOT + "caloricumRate"),
    "potassiumRate": self.get_node(self.CONTROL_PANEL.INPUT_ELEMENTS_ROOT + "potassiumRate"),
    "decarbonizerAmount": self.get_node(self.CONTROL_PANEL.INPUT_ELEMENTS_ROOT + "decarbonizerAmount"),
    "useDecarbonizer": self.get_node(self.CONTROL_PANEL.INPUT_ELEMENTS_ROOT + "useDecarbonizer")
}

func update_carbonizer_max(value : float) -> void:
    self._uiInputElements["decarbonizerAmount"].set_slider_max(value)

func force_set_slider_value(sliderID : String, value : float) -> void:
    self._uiInputElements[sliderID].force_set_slider_value(value)

func _on_slider_value_changed(sliderID: String, value : float) -> void:
    print_debug("Slider ", sliderID, " has changed value: ", value)
    request_game_data_change.emit(self.CONTROL_PANEL.INPUT_LUT[sliderID]["keyChain"], value, "FROM_LUT")

func _on_use_decarbonizer_button_pressed() -> void:
    request_game_data_change.emit(self.CONTROL_PANEL.INPUT_LUT.useDecarbonizer.keyChain, true, "FROM_LUT")

func _ready() -> void:
    for _key in self.CONTROL_PANEL.INPUT_LUT.keys():
        if _key != "useDecarbonizer":
            self._uiInputElements[_key].connect("slider_value_changed", _on_slider_value_changed)

        else:
            self._uiInputElements[_key].connect("pressed", _on_use_decarbonizer_button_pressed)