extends GutTest

#------------------------------------------
# Public behavior
#------------------------------------------

func test_resolved_promise_is_resolved() -> void:
    var promise:HPromise = HPromise.new()
    promise._resolve_immediatly(10)
    assert_true(promise.is_resolved())
    assert_false(promise.is_rejected())

func test_rejected_promise_is_rejected() -> void:
    var promise:HPromise = HPromise.new()
    promise._reject_immediatly()
    assert_false(promise.is_resolved())
    assert_true(promise.is_rejected())

#------------------------------------------
# Internal behavior
#------------------------------------------

func test_resolve_immediatly_emit_resolved_signal() -> void:
    var promise:HPromise = HPromise.new()
    watch_signals(promise)
    promise._resolve_immediatly(1)
    assert_signal_emitted_with_parameters(promise, "resolved", [1])

func test_reject_immediatly_emit_resolved_signal() -> void:
    var promise:HPromise = HPromise.new()
    watch_signals(promise)
    promise._reject_immediatly()
    assert_signal_emitted(promise, "rejected")

func test_resolve_later_emit_resolved_signal() -> void:
    var promise:HPromise = HPromise.new()
    watch_signals(promise)
    promise._resolve_later(5)
    assert_signal_not_emitted(promise, "resolved")
    await get_tree().process_frame
    assert_signal_emitted_with_parameters(promise, "resolved", [5])

func test_reject_later_emit_resolved_signal() -> void:
    var promise:HPromise = HPromise.new()
    watch_signals(promise)
    promise._reject_later()
    assert_signal_not_emitted(promise, "rejected")
    await get_tree().process_frame
    assert_signal_emitted(promise, "rejected")

