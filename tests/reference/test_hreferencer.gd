extends GutTest

var _referencer

func before_each():
    _referencer = preload("res://addons/godot-jam-toolkit/reference/hreferencer.gd").new()
    add_child_autoqfree(_referencer)
    watch_signals(_referencer)

#------------------------------------------
# Public behavior
#------------------------------------------

func test_can_not_register_null_objects() -> void:
    _referencer.register(null, 5)
    await wait_seconds(0.5)
    assert_signal_not_emitted(_referencer, "on_registered")

func test_can_register_a_non_null_object() -> void:
    var expected_expires_at:float = Time.get_ticks_msec() + 5_000
    var object := RefCounted.new()
    _referencer.register(object, 5)
    await wait_for_signal(_referencer.on_registered, 10)
    assert_signal_emitted(_referencer, "on_registered")
    var params:Array = get_signal_parameters(_referencer, "on_registered")
    assert_eq(params[0], object)
    assert_almost_eq(params[1], expected_expires_at, 500.0)

func test_objects_are_evicted() -> void:
    var object := RefCounted.new()
    _referencer.register(object, 0.5)
    await wait_for_signal(_referencer.on_eviction, 10)
    assert_signal_emitted_with_parameters(_referencer, "on_eviction", [object])

func test_manual_eviction() -> void:
    var object := RefCounted.new()
    _referencer.register(object, 1_000)
    _referencer.unregister(object)
    await wait_for_signal(_referencer.on_eviction, 10)
    assert_signal_emitted_with_parameters(_referencer, "on_eviction", [object])

func test_manual_eviction_not_triggered_for_unknown_objects() -> void:
    var object := RefCounted.new()
    _referencer.register(object, 1_000)
    _referencer.unregister(RefCounted.new())
    await wait_seconds(0.5)
    assert_signal_not_emitted(_referencer, "on_eviction")

#------------------------------------------
# Private behavior
#------------------------------------------

func test_registered_objects_in_dictionary() -> void:
    var object := RefCounted.new()
    _referencer.register(object, 100)
    await wait_for_signal(_referencer.on_registered, 10)
    assert_has(_referencer._registered_objects, object)

func test_evicted_objects_are_removed_from_dictionary() -> void:
    var object := RefCounted.new()
    _referencer.register(object, 0.5)
    await wait_for_signal(_referencer.on_eviction, 10)
    assert_does_not_have(_referencer._registered_objects, object)
