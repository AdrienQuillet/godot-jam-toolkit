extends GutTest

var _pool:HThreadPool

func after_each():
    if _pool:
        _pool.shutdown()

#------------------------------------------
# Public behavior
#------------------------------------------

func test_thread_pool_size_is_at_least_one() -> void:
    _pool = HThreadPool.new(-3)
    assert_gt(_pool.get_thread_pool_size(), 0)

func test_can_execute_tasks() -> void:
    var dict:Dictionary = {}
    _pool = HThreadPool.new(5)
    watch_signals(_pool)
    for i in 100:
        _pool.execute(func(): dict[i] = true)
    await wait_seconds(5)
    assert_signal_emit_count(_pool, "on_task_completed", 100)

func test_can_get_task_result_from_promise() -> void:
    _pool = HThreadPool.new(1)
    watch_signals(_pool)
    var promise:HPromise = _pool.submit(func(): return 10)
    await wait_for_signal(_pool.on_task_completed, 10)
    assert_eq(10, promise.get_resolved_value())

