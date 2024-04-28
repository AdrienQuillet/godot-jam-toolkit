extends CanvasLayer

#------------------------------------------
# Constants
#------------------------------------------

#------------------------------------------
# Signals
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

#------------------------------------------
# Public variables
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

@onready var _device_list_option: OptionButton = $MarginContainer/HBoxContainer/LeftContainer/DeviceContainer/DeviceListOption
@onready var _fade_slider: HSlider = $MarginContainer/HBoxContainer/LeftContainer/FadeContainer/FadeSlider

@onready var _master_volume_value_label: Label = $MarginContainer/HBoxContainer/LeftContainer/MasterVolumeContainer/MasterVolumeValueLabel
@onready var _sfx_volume_value_label: Label = $MarginContainer/HBoxContainer/LeftContainer/SFXVolumeContainer/SFXVolumeValueLabel
@onready var _music_volume_value_label: Label = $MarginContainer/HBoxContainer/LeftContainer/MusicVolumeContainer/MusicVolumeValueLabel
@onready var _ui_volume_value_label: Label = $MarginContainer/HBoxContainer/LeftContainer/UIVolumeContainer/UIVolumeValueLabel
@onready var _fade_value_label: Label = $MarginContainer/HBoxContainer/LeftContainer/FadeContainer/FadeValueLabel
@onready var _playback_speed_value_label: Label = $MarginContainer/HBoxContainer/LeftContainer/PlaybackSpeedContainer/PlaybackSpeedValueLabel

#------------------------------------------
# Godot override functions
#------------------------------------------

func _ready() -> void:
    for device in HAudioManager.get_output_devices():
        _device_list_option.add_item(device)

#------------------------------------------
# Public functions
#------------------------------------------

#------------------------------------------
# Private functions
#------------------------------------------

func _on_device_list_option_item_selected(index:int) -> void:
    HAudioManager.set_output_device(_device_list_option.get_item_text(index))

func _on_button_mouse_entered() -> void:
    HAudioManager.play_audio("ui", preload("res://demo/audio/assets/switch.ogg"))

func _on_button_pressed() -> void:
    HAudioManager.play_audio("ui", preload("res://demo/audio/assets/click.ogg"))

func _on_play_music_1_button_pressed() -> void:
    HAudioManager.play_audio("music", preload("res://demo/audio/assets/After the End.mp3"), _fade_slider.value, 0)

func _on_play_music_2_button_pressed() -> void:
    HAudioManager.play_audio("music", preload("res://demo/audio/assets/Guerilla Tactics.mp3"), _fade_slider.value, 0)

func _on_stop_music_button_pressed() -> void:
    HAudioManager.stop_audio("music", _fade_slider.value, 0)

func _on_fade_slider_value_changed(value: float) -> void:
    _fade_value_label.text = "%.2f" % value

func _on_ui_volume_slider_value_changed(value: float) -> void:
    _ui_volume_value_label.text = "%.2f" % value
    HAudioManager.set_volume("ui", value)

func _on_music_volume_slider_value_changed(value: float) -> void:
    _music_volume_value_label.text = "%.2f" % value
    HAudioManager.set_volume("music", value)

func _on_sfx_volume_slider_value_changed(value: float) -> void:
    _sfx_volume_value_label.text = "%.2f" % value
    HAudioManager.set_volume("sfx", value)

func _on_master_volume_slider_value_changed(value: float) -> void:
    _master_volume_value_label.text = "%.2f" % value
    HAudioManager.set_volume("master", value)

func _on_playback_speed_slider_value_changed(value: float) -> void:
    _playback_speed_value_label.text = "%.2f" % value
    HAudioManager.set_playback_speed_scale(value)
