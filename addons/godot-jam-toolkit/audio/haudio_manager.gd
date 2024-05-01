extends Node
class_name HAudioManager

##
## Audio manager for Godot.
## [br][br]
## This node allows to easily play sounds, musics, sfx effects in your game. Each audio can
## be played on a bus, and can also be played on a specific channel for a more precise audio management.
##

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
    # Buses can be configured via editor. There is the Master bus by default,
    # plus other user-defined buses
    _initialize_default_buses()

#------------------------------------------
# Public functions
#------------------------------------------

## Modify the maximum number of channel that can exists in this bus. Default is [code]16[/code].
## Channel count can not be lower than [code]1[/code].
## [br]
## If maximum number of channel is reached in a bus, and all channel are active, then it is not possible
## to play audio anymore.
func set_max_channel_count(bus_name:String, max_channel_count:int) -> void:
    _get_bus_by_name(bus_name).set_max_channel_count(max_channel_count)


## Get the list of available output devices. See [method set_output_device] to modify the
## current output device.
func get_output_devices() -> PackedStringArray:
    return AudioServer.get_output_device_list()

## Modify the audio output device for the application. See [method get_output_devices] to get
## available device list.
func set_output_device(device_name:String) -> void:
    AudioServer.output_device = device_name


## Modify the volume of the given bus. Volume is expressed in percent (from [code]0[/code] to [code]1[/code])
## and automatically transformed into decibel.
## [br]
## If [code]channel_index[/code] is [code]-1[/code], all bus channels
## are affected, else only the specified channel is affected.
func set_volume(bus_name:String, volume_percent:float, channel_index:int = -1) -> void:
    _get_bus_by_name(bus_name).set_volume(volume_percent, channel_index)

## Returns the volume of the given bus, in percent (from [code]0[/code] to [code]1[/code]).
## Use [method @GlobalScope.linear_to_db] to transform this value into decibels.
## [br]
## If [code]channel_index[/code] is [code]-1[/code], returns the bus volume, else returns
## the volume of the specified channel.
func get_volume(bus_name:String, channel_index:int = -1) -> float:
    return _get_bus_by_name(bus_name).get_volume(channel_index)

## Returns [code]true[/code] if the given bus is mute, [code]false[/code] otherwise.
func is_mute(bus_name:String) -> bool:
    return _get_bus_by_name(bus_name).is_mute()

## Mute the given bus.
func mute(bus_name:String) -> void:
    _get_bus_by_name(bus_name).mute()

## Unmute the given bus. Has no effect is the bus is not muted. See also  [is_mute].
func unmute(bus_name:String) -> void:
    _get_bus_by_name(bus_name).unmute()

## Returns the global playback speed scale.
func get_playback_speed_scale() -> float:
    return AudioServer.playback_speed_scale

## Modify the global playback speed scale, i.e. the rate at which audio is played.
func set_playback_speed_scale(scale:float) -> void:
    AudioServer.playback_speed_scale = max(0.001, scale)


## If [code]channel_index[/code] is [code]-1[/code], returns [code]true[/code] if at least one channel
## of the specified bus is playing, [code]false[/code] otherwise.
## [br]
## Otherwise, returns [code]true[/code] if the given channel is playing audio, [code]false[/code] otherwise.
func is_playing(bus_name:String, channel_index:int = -1) -> bool:
    return _get_bus_by_name(bus_name).is_playing(channel_index)

## Play the given audio resource in the specified bus.
## [br][br]
## If [code]fade_in[/code] is greater than 0, a fade in effect is applied for the given time.
## [br][br]
## If [code]channel_index[/code] is specified, the audio stream is played on the specific channel, otherwise it is
## played on the first available channel of this bus. If no channel is available, a new channel is created if
## channel limit is not reached. Playing on an active channel make the previous audio stream stop immediately,
## without fade out effect.
func play(bus_name:String, audio_path:String, fade_in:float = 0.0, channel_index:int = -1) -> void:
    play_audio(bus_name, load(audio_path), fade_in, channel_index)

## Play the given [AudioStream] in the specified bus.
## [br][br]
## If [code]fade_in[/code] is greater than 0, a fade in effect is applied for the given time.
## [br][br]
## If [code]channel_index[/code] is specified, the audio stream is played on the specific channel, otherwise it is
## played on the first available channel of this bus. If no channel is available, a new channel is created if
## channel limit is not reached. Playing on an active channel make the previous audio stream stop immediately,
## without fade out effect.
func play_audio(bus_name:String, audio:AudioStream, fade_in:float = 0.0, channel_index:int = -1) -> void:
    _get_bus_by_name(bus_name).play(audio, fade_in, channel_index)

## Stop audio streams on the secified bus.
## [br][br]
## If [code]fade_out[/code] is greater than 0, a fade out effect is applied for the given time.
## [br][br]
## If [code]channel_index[/code] is specified, only this channel is stopped. Otherwise all channels of
## the bus are stopped.
func stop_audio(bus_name:String, fade_out:float = 0.0, channel_index:int = -1) -> void:
    _get_bus_by_name(bus_name).stop(fade_out, channel_index)

## Stop all audio on all buses.
func stop_all_audio(fade_out:float = 0.0) -> void:
    for bus in _buses_by_name.values():
        bus.stop(fade_out, -1)

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
