extends RefCounted
class_name HAudioBus

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

# This bus name, with the same case as in [AudioServer]
var _bus_name:String
# This bus identifier, same as in [AusioServer]
var _bus_id:int
# The node that will olds all player nodes for this bus
var _container:Node
# Maximum number of allowed channels in this bus. When reached and no channel is
# available, nothing can be played
var _max_channel_count:int = 16
# Mapping between channel identifier and the player
var _player_by_channel_id:Dictionary = {}

#------------------------------------------
# Godot override functions
#------------------------------------------

func _init(name:String, id:int, parent_node:Node) -> void:
    _bus_name = name
    _bus_id = id
    _container = Node.new()
    _container.name = "%s[%s]" % [_bus_name, _bus_id]
    parent_node.add_child(_container)

#------------------------------------------
# Public functions
#------------------------------------------

func set_max_channel_count(max_channel_count:int) -> void:
    _max_channel_count = clamp(max_channel_count, 1, 999999)
    # Delete channel abode limit immédiatly
    if _max_channel_count != 0:
        for channel_id in _player_by_channel_id:
            if channel_id >= _max_channel_count:
                _player_by_channel_id[channel_id].stop()
                _player_by_channel_id[channel_id].destroy()
                _player_by_channel_id.erase(channel_id)

func get_available_channel_id() -> int:
    # First, find a free audio player
    for audio_player in _player_by_channel_id.values():
        if audio_player.is_available():
            return audio_player.get_channel_id()

    # If there is no available audio player, check for unused channel id
    # First, get the new player channel id
    var channel_id:int = -1
    var channel_ids:Array = Array(_player_by_channel_id.keys())
    channel_ids.sort()
    for i in channel_ids.size():
        if channel_ids[i] != i:
            channel_id = i
            break
    if channel_id == -1:
        channel_id = channel_ids.size()

    # Now verify that this channel is allowed
    if _max_channel_count == 0 or channel_id < _max_channel_count:
        return channel_id

    # No available channel !
    return -1

func set_volume(volume_percent:float, channel_index:int) -> void:
    volume_percent = clamp(volume_percent, 0.0, 1.0)
    if channel_index == -1:
        AudioServer.set_bus_volume_db(_bus_id, linear_to_db(volume_percent))
    else:
        _get_player(channel_index).set_volume(volume_percent)

func get_volume(channel_index:int = -1) -> float:
    if channel_index == -1:
        return AudioServer.get_bus_volume_db(_bus_id)
    else:
        return _get_player(channel_index).get_volume()

func is_mute() -> bool:
    return AudioServer.is_bus_mute(_bus_id)

func mute() -> void:
    AudioServer.set_bus_mute(_bus_id, true)

func unmute() -> void:
    AudioServer.set_bus_mute(_bus_id, false)

func is_playing(channel_index:int) -> bool:
    if channel_index == -1:
        for player in _player_by_channel_id.values():
            if not player.is_available():
                return true
        return false
    else:
        return not _get_player(channel_index).is_available()

func play(audio:AudioStream, fade_in:float = 0.0, channel_index:int = -1) -> int:
    var player:HAudioStreamPlayer = _get_first_available_player() if channel_index == -1 else _get_player(channel_index)
    if player == null:
        return -1

    player.play(audio, fade_in)
    return player.get_channel_id()

func stop(fade_out:float = 0.0, channel_index:int = -1) -> void:
    if channel_index == -1:
        for player in _player_by_channel_id.values():
            player.stop(fade_out)
    else:
        var player:HAudioStreamPlayer = _get_player(channel_index)
        if player == null:
            return
        player.stop(fade_out)

#------------------------------------------
# Private functions
#------------------------------------------

func _get_first_available_player() -> HAudioStreamPlayer:
    var available_channel_id:int = get_available_channel_id()
    if available_channel_id == -1:
        push_error("No available channel on bus %s and maximum channel count is reached." % _bus_id)
        return null
    return _get_player(available_channel_id)

func _get_player(channel_id:int) -> HAudioStreamPlayer:
    if _max_channel_count != 0 and channel_id >= _max_channel_count:
        push_error("Can not get channel %s on bus %s: max channel count is %s" % [channel_id, _bus_id, _max_channel_count])
        return null

    var player:HAudioStreamPlayer = _player_by_channel_id.get(channel_id, null)
    if player == null:
        player = _allocate_player(channel_id)
        _player_by_channel_id[channel_id] = player

    return player

func _allocate_player(channel_id:int) -> HAudioStreamPlayer:
    var underlying_player:AudioStreamPlayer = AudioStreamPlayer.new()
    underlying_player.name = "Channel-%s" % channel_id
    underlying_player.bus = _bus_name
    return HAudioStreamPlayer.new(channel_id, underlying_player, _container)
