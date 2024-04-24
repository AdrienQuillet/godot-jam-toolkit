extends Node
# Autoload

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

# Map bus name to the bus data
var _buses_by_name:Dictionary = {}

#------------------------------------------
# Godot override functions
#------------------------------------------

func _ready() -> void:
    _initialize_default_buses()

#------------------------------------------
# Public functions
#------------------------------------------

func get_output_devices() -> PackedStringArray:
    return AudioServer.get_output_device_list()

func set_output_device(device_name:String) -> void:
    AudioServer.output_device = device_name



func set_volume(bus_name:String, volume_percent:float, channel_index:int = -1) -> void:
    _get_bus_by_name(bus_name).set_volume(volume_percent, channel_index)

func get_volume(bus_name:String, channel_index:int = -1) -> float:
    return _get_bus_by_name(bus_name).get_volume(channel_index)

func is_mute(bus_name:String) -> bool:
    return _get_bus_by_name(bus_name).is_mute()

func mute(bus_name:String) -> void:
    _get_bus_by_name(bus_name).mute()

func unmute(bus_name:String) -> void:
    _get_bus_by_name(bus_name).unmute()



func set_playback_speed_scale(scale:float) -> void:
    AudioServer.playback_speed_scale = max(0.001, scale)

func is_playing(bus_name:String, channel_index:int = -1) -> bool:
    return _get_bus_by_name(bus_name).is_playing(channel_index)

func play_audio(bus_name:String, audio:AudioStream, fade_in:float = 0.0, channel_index:int = -1) -> void:
    _get_bus_by_name(bus_name).play(audio, fade_in, channel_index)

func stop_audio(bus_name:String, fade_out:float = 0.0, channel_index:int = -1) -> void:
    _get_bus_by_name(bus_name).stop(fade_out, channel_index)



#------------------------------------------
# Private functions
#------------------------------------------

func _initialize_default_buses() -> void:
    for i in AudioServer.bus_count:
        var bus_name:String = AudioServer.get_bus_name(i)
        _buses_by_name[bus_name.to_lower()] = HAudioBus.new(bus_name, i, self)

func _get_bus_by_name(bus_name:String) -> HAudioBus:
    var bus:HAudioBus = _buses_by_name.get(bus_name.to_lower(), null)
    if bus == null:
        bus = _create_bus(bus_name)
    return bus

func _create_bus(bus_name:String) -> HAudioBus:
    var bus_index:int = AudioServer.bus_count
    AudioServer.add_bus()
    AudioServer.set_bus_name(bus_index, bus_name)
    var bus:HAudioBus = HAudioBus.new(bus_name, bus_index, self)
    _buses_by_name[bus_name.to_lower()] = bus
    return bus
