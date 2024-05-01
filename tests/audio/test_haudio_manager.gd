extends GutTest

const AUDIO_RESOURCE_PATH:String = "res://tests/audio/test_audio.mp3"
const AUDIO_RESOURCE:AudioStream = preload(AUDIO_RESOURCE_PATH)

var _manager:HAudioManager

func before_each() -> void:
    _manager = HAudioManager.new()
    add_child(_manager)

func after_each() -> void:
    _manager.set_volume("master", 1.0)
    remove_child(_manager)
    _manager.queue_free()

func test_can_play_sound_on_a_bus() -> void:
    _manager.play_audio("master", AUDIO_RESOURCE)
    await wait_seconds(0.2)
    assert_true(_manager.is_playing("master"))

func test_can_play_sound_on_a_new_bus() -> void:
    _manager.play_audio("this_is_a_new_bus", AUDIO_RESOURCE)
    await wait_seconds(0.2)
    assert_true(_manager.is_playing("this_is_a_new_bus"))

func test_can_play_sound_on_a_bus_channel() -> void:
    _manager.play_audio("master", AUDIO_RESOURCE, 0.0, 5)
    await wait_seconds(0.2)
    assert_false(_manager.is_playing("master", 0))
    assert_true(_manager.is_playing("master", 5))

func test_can_play_sounds_on_bus_channels() -> void:
    _manager.play_audio("master", AUDIO_RESOURCE, 0.0, 0)
    _manager.play_audio("master", AUDIO_RESOURCE, 0.0, 1)
    _manager.play_audio("master", AUDIO_RESOURCE, 0.0, 2)
    await wait_seconds(0.2)
    assert_true(_manager.is_playing("master", 0))
    assert_true(_manager.is_playing("master", 1))
    assert_true(_manager.is_playing("master", 2))

func test_fade_in() -> void:
    _manager.play_audio("master", AUDIO_RESOURCE, 1, 0)
    assert_almost_eq(_manager.get_volume("master", 0), 0.0, 0.001)
    await wait_seconds(0.5)
    assert_between(_manager.get_volume("master", 0), 0.2, 0.8)
    await wait_seconds(0.6)
    assert_almost_eq(_manager.get_volume("master", 0), 1.0, 0.001)

func test_stop_audio_on_channel() -> void:
    _manager.play_audio("master", AUDIO_RESOURCE, 1, 0)
    _manager.play_audio("master", AUDIO_RESOURCE, 1, 1)
    await wait_seconds(0.2)
    _manager.stop_audio("master", 0, 0)
    assert_false(_manager.is_playing("master", 0))
    assert_true(_manager.is_playing("master", 1))

func test_stop_audio_on_bus() -> void:
    _manager.play_audio("master", AUDIO_RESOURCE, 1, 0)
    _manager.play_audio("master", AUDIO_RESOURCE, 1, 1)
    await wait_seconds(0.2)
    _manager.stop_audio("master")
    assert_false(_manager.is_playing("master", 0))
    assert_false(_manager.is_playing("master", 1))

func test_stop_audio_on_buses() -> void:
    _manager.play_audio("master", AUDIO_RESOURCE, 1)
    _manager.play_audio("other", AUDIO_RESOURCE, 1)
    await wait_seconds(0.2)
    _manager.stop_all_audio()
    assert_false(_manager.is_playing("master"))
    assert_false(_manager.is_playing("other"))

func test_fade_out() -> void:
    _manager.play_audio("master", AUDIO_RESOURCE, 0.0, 0)
    await wait_seconds(0.1)
    _manager.stop_audio("master", 1.0)
    assert_almost_eq(_manager.get_volume("master", 0), 1.0, 0.001)
    await wait_seconds(0.5)
    assert_between(_manager.get_volume("master", 0), 0.2, 0.8)
    await wait_seconds(0.6)
    assert_almost_eq(_manager.get_volume("master", 0), 0.0, 0.001)

func test_fade_out_preserves_current_volume() -> void:
    _manager.play_audio("master", AUDIO_RESOURCE, 0.0, 0)
    _manager.set_volume("master", 0.2, 0)
    await wait_seconds(0.1)
    _manager.stop_audio("master", 1.0)
    await wait_seconds(0.1)
    assert_almost_eq(_manager.get_volume("master", 0), 0.2, 0.3)

func test_set_bus_volume() -> void:
    _manager.set_volume("master", 0.5)
    assert_almost_eq(_manager.get_volume("master"), 0.5, 0.001)

func test_set_bus_channel_volume() -> void:
    _manager.set_volume("master", 0.5, 0)
    _manager.set_volume("master", 0.7, 1)
    _manager.set_volume("master", 2, 2)
    assert_almost_eq(_manager.get_volume("master"), 1.0, 0.001)
    assert_almost_eq(_manager.get_volume("master", 0), 0.5, 0.001)
    assert_almost_eq(_manager.get_volume("master", 1), 0.7, 0.001)
    assert_almost_eq(_manager.get_volume("master", 2), 1, 0.001)

func test_mute_bus() -> void:
    _manager.mute("master")
    assert_true(_manager.is_mute("master"))
    assert_true(AudioServer.is_bus_mute(0))

func test_unmute_bus() -> void:
    _manager.mute("master")
    _manager.unmute("master")
    assert_false(_manager.is_mute("master"))
    assert_false(AudioServer.is_bus_mute(0))
