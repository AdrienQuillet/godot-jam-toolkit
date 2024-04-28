extends RefCounted
class_name HAudioStreamPlayer

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

# The channel id
var _channel_id:int
# The underlying audio stream player node
var _player_node:Node
# Is this player available or not
var _available:bool = true
# Tween use to fade in the player volume DB on play
var _fade_tween:Tween

#------------------------------------------
# Godot override functions
#------------------------------------------

func _init(channel_id:int, player_node:Node, parent_node:Node) -> void:
    _channel_id = channel_id
    _player_node = player_node
    parent_node.add_child(_player_node)
    _player_node.finished.connect(_on_player_node_audio_finished)

#------------------------------------------
# Public functions
#------------------------------------------

func get_channel_id() -> int:
    return _channel_id

func is_available() -> bool:
    return _available

func set_volume(volume_percent:float) -> void:
    _player_node.volume_db = linear_to_db(volume_percent)

func get_volume() -> float:
    return db_to_linear(_player_node.volume_db)

func play(audio:AudioStream, fade_in:float) -> void:
    fade_in = max(0.0, fade_in)
    _available = false
    _player_node.stream = audio
    if is_zero_approx(fade_in):
        set_volume(1.0)
    else:
        set_volume(0.0)
        _fade_tween = _player_node.create_tween()
        _fade_tween.tween_method(set_volume, 0.0, 1.0, fade_in)
    _player_node.play()

func stop(fade_out:float) -> void:
    if _fade_tween:
        _fade_tween.stop()
        _fade_tween.kill()
        _fade_tween = null
    if is_zero_approx(fade_out):
        _do_stop_player_and_make_available()
    else:
        _fade_tween = _player_node.create_tween()
        _fade_tween.tween_method(set_volume, get_volume(), 0.0, fade_out)
        _fade_tween.finished.connect(_do_stop_player_and_make_available)

func destroy() -> void:
    stop(0.0)
    _player_node.queue_free()
    _player_node = null

#------------------------------------------
# Private functions
#------------------------------------------

func _on_player_node_audio_finished() -> void:
    _available = true

func _do_stop_player_and_make_available() -> void:
    _player_node.stop()
    _available = true
