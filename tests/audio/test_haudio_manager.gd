extends GutTest

const AUDIO_RESOURCE_PATH:String = "res://tests/audio/test_audio.mp3"
const AUDIO_RESOURCE:AudioStream = preload(AUDIO_RESOURCE_PATH)

func after_each() -> void:
    HAudioManager.stop_all_audio()
    HAudioManager.set_volume("master", 1.0)

func test_can_play_sound_on_a_bus() -> void:
    HAudioManager.play_audio("master", AUDIO_RESOURCE)
    await wait_seconds(0.2)
    assert_true(HAudioManager.is_playing("master"))

func test_can_play_sound_on_a_new_bus() -> void:
    HAudioManager.play_audio("this_is_a_new_bus", AUDIO_RESOURCE)
    await wait_seconds(0.2)
    assert_true(HAudioManager.is_playing("this_is_a_new_bus"))

func test_can_play_sound_on_a_bus_channel() -> void:
    HAudioManager.play_audio("master", AUDIO_RESOURCE, 0.0, 5)
    await wait_seconds(0.2)
    assert_false(HAudioManager.is_playing("master", 0))
    assert_true(HAudioManager.is_playing("master", 5))

func test_can_play_sounds_on_bus_channels() -> void:
    HAudioManager.play_audio("master", AUDIO_RESOURCE, 0.0, 0)
    HAudioManager.play_audio("master", AUDIO_RESOURCE, 0.0, 1)
    HAudioManager.play_audio("master", AUDIO_RESOURCE, 0.0, 2)
    await wait_seconds(0.2)
    assert_true(HAudioManager.is_playing("master", 0))
    assert_true(HAudioManager.is_playing("master", 1))
    assert_true(HAudioManager.is_playing("master", 2))

func test_fade_in() -> void:
    HAudioManager.play_audio("master", AUDIO_RESOURCE, 1, 0)
    assert_almost_eq(HAudioManager.get_volume("master", 0), 0.0, 0.001)
    await wait_seconds(0.5)
    assert_between(HAudioManager.get_volume("master", 0), 0.2, 0.8)
    await wait_seconds(0.6)
    assert_almost_eq(HAudioManager.get_volume("master", 0), 1.0, 0.001)

func test_stop_audio_on_channel() -> void:
    HAudioManager.play_audio("master", AUDIO_RESOURCE, 1, 0)
    HAudioManager.play_audio("master", AUDIO_RESOURCE, 1, 1)
    await wait_seconds(0.2)
    HAudioManager.stop_audio("master", 0, 0)
    assert_false(HAudioManager.is_playing("master", 0))
    assert_true(HAudioManager.is_playing("master", 1))

func test_stop_audio_on_bus() -> void:
    HAudioManager.play_audio("master", AUDIO_RESOURCE, 1, 0)
    HAudioManager.play_audio("master", AUDIO_RESOURCE, 1, 1)
    await wait_seconds(0.2)
    HAudioManager.stop_audio("master")
    assert_false(HAudioManager.is_playing("master", 0))
    assert_false(HAudioManager.is_playing("master", 1))

func test_stop_audio_on_buses() -> void:
    HAudioManager.play_audio("master", AUDIO_RESOURCE, 1)
    HAudioManager.play_audio("other", AUDIO_RESOURCE, 1)
    await wait_seconds(0.2)
    HAudioManager.stop_all_audio()
    assert_false(HAudioManager.is_playing("master"))
    assert_false(HAudioManager.is_playing("other"))

func test_fade_out() -> void:
    HAudioManager.play_audio("master", AUDIO_RESOURCE, 0.0, 0)
    await wait_seconds(0.1)
    HAudioManager.stop_audio("master", 1.0)
    assert_almost_eq(HAudioManager.get_volume("master", 0), 1.0, 0.001)
    await wait_seconds(0.5)
    assert_between(HAudioManager.get_volume("master", 0), 0.2, 0.8)
    await wait_seconds(0.6)
    assert_almost_eq(HAudioManager.get_volume("master", 0), 0.0, 0.001)

func test_fade_out_preserves_current_volume() -> void:
    HAudioManager.play_audio("master", AUDIO_RESOURCE, 0.0, 0)
    HAudioManager.set_volume("master", 0.2, 0)
    await wait_seconds(0.1)
    HAudioManager.stop_audio("master", 1.0)
    await wait_seconds(0.1)
    assert_almost_eq(HAudioManager.get_volume("master", 0), 0.2, 0.3)

func test_set_bus_volume() -> void:
    HAudioManager.set_volume("master", 0.5)
    assert_almost_eq(HAudioManager.get_volume("master"), 0.5, 0.001)

func test_set_bus_channel_volume() -> void:
    HAudioManager.set_volume("master", 0.5, 0)
    HAudioManager.set_volume("master", 0.7, 1)
    HAudioManager.set_volume("master", 2, 2)
    assert_almost_eq(HAudioManager.get_volume("master"), 1.0, 0.001)
    assert_almost_eq(HAudioManager.get_volume("master", 0), 0.5, 0.001)
    assert_almost_eq(HAudioManager.get_volume("master", 1), 0.7, 0.001)
    assert_almost_eq(HAudioManager.get_volume("master", 2), 1, 0.001)

func test_mute_bus() -> void:
    HAudioManager.mute("master")
    assert_true(HAudioManager.is_mute("master"))
    assert_true(AudioServer.is_bus_mute(0))

func test_unmute_bus() -> void:
    HAudioManager.mute("master")
    HAudioManager.unmute("master")
    assert_false(HAudioManager.is_mute("master"))
    assert_false(AudioServer.is_bus_mute(0))
