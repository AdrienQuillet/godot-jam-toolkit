extends GutTest

const TEST_SCENE_PATH:String = "res://tests/scene/loader/test_scene.tscn"

func before_all():
    watch_signals(HSceneLoader)

#------------------------------------------
# Public behavior
#------------------------------------------

func test_immediate_scene_load() -> void:
    var scene:PackedScene = HSceneLoader.immediate_load_scene(TEST_SCENE_PATH)
    assert_not_null(scene)

func test_immediate_scene_instantiate() -> void:
    var node:Node = HSceneLoader.immediate_scene_instantiate(TEST_SCENE_PATH)
    assert_not_null(node)

func test_async_scene_load_using_direct_signals() -> void:
    HSceneLoader.async_load_scene(TEST_SCENE_PATH)
    await wait_for_signal(HSceneLoader.on_scene_load_finished, 10)
    var params:Array = get_signal_parameters(HSceneLoader, "on_scene_load_finished")
    assert_eq(params[0], TEST_SCENE_PATH)
    assert_is(params[1], PackedScene)

func test_async_scene_load_using_promise_signals() -> void:
    var promise:HPromise = HSceneLoader.async_load_scene(TEST_SCENE_PATH)
    await wait_for_signal(promise.resolved, 10)
    var params:Array = get_signal_parameters(promise, "resolved")
    assert_is(params[0], PackedScene)

func test_async_scene_instantiate_using_direct_signals() -> void:
    HSceneLoader.async_scene_instantiate(TEST_SCENE_PATH)
    await wait_for_signal(HSceneLoader.on_scene_instantiation_finished, 10)
    var params:Array = get_signal_parameters(HSceneLoader, "on_scene_instantiation_finished")
    assert_eq(params[0], TEST_SCENE_PATH)
    assert_is(params[1], Node)

func test_async_scene_instantiate_using_promise_signals() -> void:
    var promise:HPromise = HSceneLoader.async_scene_instantiate(TEST_SCENE_PATH)
    await wait_for_signal(promise.resolved, 10)
    var params:Array = get_signal_parameters(promise, "resolved")
    assert_is(params[0], Node)
