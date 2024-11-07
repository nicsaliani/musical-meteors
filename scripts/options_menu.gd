class_name OptionsMenu extends Control

## ON-READY

signal open_main_menu()

# Audio Percent Labels
@onready var master_percent_label: Label = $AudioContainer/MasterContainer/MasterPercentLabel
@onready var music_percent_label: Label = $AudioContainer/MusicContainer/MusicPercentLabel
@onready var sound_percent_label: Label = $AudioContainer/SoundContainer/SoundPercentLabel

## VARIABLES


## FUNCTIONS
func _ready() -> void:
	hide()
	
# SIGNAL: On Options Menu Opened
func _on_main_menu_open_options_menu() -> void:
	show()

func _on_back_button_pressed() -> void:
	hide()
	open_main_menu.emit()

# SIGNAL: On Slider Value Changed
func _on_master_slider_value_changed(value: float) -> void:
	master_percent_label.text = str(value) + "%"

func _on_music_slider_value_changed(value: float) -> void:
	music_percent_label.text = str(value) + "%"

func _on_sound_slider_value_changed(value: float) -> void:
	sound_percent_label.text = str(value) + "%"
