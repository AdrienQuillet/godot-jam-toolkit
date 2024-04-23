extends GutTest

var _sprite:Sprite2D

func before_each():
    _sprite = Sprite2D.new()
    add_child(_sprite)

func after_each():
    _sprite.queue_free()

#------------------------------------------
# Public behavior
#------------------------------------------

func test_autostart() -> void:
    HTweenBuilder.build_tween(_sprite) \
        .autostart() \
        .new_step().tween_property(_sprite, "position:x", 100, 0.1) \
        .build()
    await wait_seconds(0.2)
    assert_eq(_sprite.position.x, 100.0)

func test_manual_start() -> void:
    var tween:HTween = HTweenBuilder.build_tween(_sprite) \
        .manual_start() \
        .new_step().tween_property(_sprite, "position:x", 100, 0.1) \
        .build()
    await wait_seconds(0.2)
    assert_eq(_sprite.position.x, 0.0)
    tween.play()
    await wait_seconds(0.2)
    assert_eq(_sprite.position.x, 100.0)

func test_unitary_tween_callback() -> void:
    var res:Array[int] = [0]
    HTweenBuilder.build_tween(_sprite) \
        .new_step().tween_callable(func(): res[0] += 1).delay(0.5) \
        .build()
    await wait_seconds(0.1)
    assert_eq(res[0], 0)
    await wait_seconds(0.5)
    assert_eq(res[0], 1)

func test_unitary_tween_interval() -> void:
    var res:Array[int] = [0]
    HTweenBuilder.build_tween(_sprite) \
        .new_step().tween_interval(0.5).tween_callable(func(): res[0] += 1) \
        .build()
    await wait_seconds(0.2)
    assert_eq(res[0], 0)
    await wait_seconds(0.7)
    assert_eq(res[0], 1)

func test_unitary_tween_method() -> void:
    var res:Array[int] = [0]
    HTweenBuilder.build_tween(_sprite) \
        .new_step().tween_method(func(val): res[0] = val, 0, 10, 1) \
        .build()
    await wait_seconds(0.5)
    assert_between(res[0], 4, 6)
    await wait_seconds(0.6)
    assert_eq(res[0], 10)

func test_unitary_tween_property() -> void:
    HTweenBuilder.build_tween(_sprite) \
        .new_step().tween_property(_sprite, "position:y", 100.0, 0.2) \
        .build()
    await wait_seconds(0.3)
    assert_eq(_sprite.position.y, 100.0)

func test_unitary_tween_property_as_relative() -> void:
    _sprite.position.x = 100
    HTweenBuilder.build_tween(_sprite) \
        .new_step().tween_property(_sprite, "position:x", 50.0, 0.2).as_relative() \
        .build()
    await wait_seconds(0.3)
    assert_eq(_sprite.position.x, 150.0)

func test_chain_step() -> void:
    HTweenBuilder.build_tween(_sprite) \
        .new_step(false) \
            .tween_property(_sprite, "position:x", 100.0, 0.2) \
            .tween_property(_sprite, "position:y", 100.0, 0.2) \
        .build()
    await wait_seconds(0.1)
    assert_between(_sprite.position.x, 20.0, 80.0)
    assert_eq(_sprite.position.y, 0.0)
    await wait_seconds(0.2)
    assert_eq(_sprite.position.x, 100.0)
    assert_between(_sprite.position.y, 20.0, 80.0)
    await wait_seconds(0.2)
    assert_eq(_sprite.position.x, 100.0)
    assert_eq(_sprite.position.y, 100.0)

func test_parallel_step() -> void:
    HTweenBuilder.build_tween(_sprite) \
        .new_step(true) \
            .tween_property(_sprite, "position:x", 100.0, 0.2) \
            .tween_property(_sprite, "position:y", 100.0, 0.2) \
        .build()
    await wait_seconds(0.1)
    assert_between(_sprite.position.x, 20.0, 80.0)
    assert_between(_sprite.position.y, 20.0, 80.0)
    await wait_seconds(0.2)
    assert_eq(_sprite.position.x, 100.0)
    assert_eq(_sprite.position.y, 100.0)

func test_multiple_steps() -> void:
    HTweenBuilder.build_tween(_sprite) \
        .new_step(true) \
            .tween_property(_sprite, "position:x", 100.0, 0.2) \
            .tween_property(_sprite, "position:y", 100.0, 0.2) \
        .new_step(false) \
            .tween_property(_sprite, "position:y", 200.0, 0.2) \
        .build()
    await wait_seconds(0.15)
    assert_between(_sprite.position.x, 20.0, 90.0)
    assert_between(_sprite.position.y, 20.0, 90.0)
    await wait_seconds(0.4)
    assert_eq(_sprite.position.x, 100.0)
    assert_eq(_sprite.position.y, 200.0)
