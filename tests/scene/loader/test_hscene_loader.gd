extends GutTest

const TEST_SCENE_PATH:String = "res://tests/scene/loader/test_scene.tscn"

var _loader:HSceneLoader

func before_each() -> void:
    _loader = HSceneLoader.new()
    add_child(_loader)
    watch_signals(_loader)

func after_each():
    remove_child(_loader)
    _loader.queue_free()

#------------------------------------------
# Public behavior
#------------------------------------------

func test_immediate_scene_load() -> void:
    var scene:PackedScene = _loader.immediate_load_scene(TEST_SCENE_PATH)
    assert_not_null(scene)

func test_immediate_scene_instantiate() -> void:
    var node:Node = _loader.immediate_scene_instantiate(TEST_SCENE_PATH)
    assert_not_null(node)

func test_async_scene_load_using_direct_signals() -> void:
    _loader.async_load_scene(TEST_SCENE_PATH)
    await wait_for_signal(_loader.on_scene_load_finished, 10)
    var params:Array = get_signal_parameters(_loader, "on_scene_load_finished")
    assert_eq(params[0], TEST_SCENE_PATH)
    assert_is(params[1], PackedScene)

func test_async_scene_load_using_promise_signals() -> void:
    var promise:HPromise = _loader.async_load_scene(TEST_SCENE_PATH)
    await wait_for_signal(promise.resolved, 10)
    var params:Array = get_signal_parameters(promise, "resolved")
    assert_is(params[0], PackedScene)

func test_async_scene_instantiate_using_direct_signals() -> void:
    _loader.async_scene_instantiate(TEST_SCENE_PATH)
    await wait_for_signal(_loader.on_scene_instantiation_finished, 10)
    var params:Array = get_signal_parameters(_loader, "on_scene_instantiation_finished")
    assert_eq(params[0], TEST_SCENE_PATH)
    assert_is(params[1], Node)

func test_async_scene_instantiate_using_promise_signals() -> void:
    var promise:HPromise = _loader.async_scene_instantiate(TEST_SCENE_PATH)
    await wait_for_signal(promise.resolved, 10)
    var params:Array = get_signal_parameters(promise, "resolved")
    assert_is(params[0], Node)
