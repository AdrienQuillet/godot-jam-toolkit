@tool
extends RefCounted
class_name HThreadPool

##
## Utility class to execute tasks in background
##

#------------------------------------------
# Constants
#------------------------------------------

#------------------------------------------
# Signals
#------------------------------------------

## Indicates that a task has been completed
signal on_task_completed

#------------------------------------------
# Exports
#------------------------------------------

#------------------------------------------
# Public variables
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

# Is this pool still running ?
var _running:bool = true
# All pool threads
var _threads:Array[Thread]
# All running tasks
var _tasks:Array[Task]
# Allow to protect shared resources among threads
var _mutex:Mutex
# Allow to protect shared resources among threads
var _semaphore:Semaphore

#------------------------------------------
# Godot override functions
#------------------------------------------

func _init(thread_count:int) -> void:
    _threads.resize(max(1, thread_count))
    _mutex = Mutex.new()
    _semaphore = Semaphore.new()
    for i in range(_threads.size()):
        _threads[i] = Thread.new()
        _threads[i].start(_run.bind(_threads[i]))

func _notification(what: int) -> void:
    if what == NOTIFICATION_PREDELETE:
        if _running:
            shutdown()

#------------------------------------------
# Public functions
#------------------------------------------

## Returns the thread pool size
func get_thread_pool_size() -> int:
    return _threads.size()

## Executes the given task at some time in the future.
func execute(callable:Callable) -> void:
    _mutex.lock()
    _tasks.append(Task.new(callable))
    _mutex.unlock()
    _semaphore.post()

## Submits a value-returning task for execution and returns a [HPromise] representing the pending results of the task.
## The [method HPromise.get_resolved_value] method will return the task's result upon successful completion.
func submit(callable:Callable) -> HPromise:
    _mutex.lock()
    var new_task:Task = Task.new(callable)
    _tasks.append(new_task)
    _mutex.unlock()
    _semaphore.post()

    return new_task._promise

## Initiates an orderly shutdown in which previously submitted tasks are executed, but no new tasks will
## be accepted. Invocation has no additional effect if already shut down.
func shutdown() -> void:
    if not _running:
        return
    _mutex.lock()
    _running = false
    _mutex.unlock()

    for i in range(_threads.size()):
        _semaphore.post()
    for i in range(_threads.size()):
        _threads[i].wait_to_finish()

#------------------------------------------
# Private functions
#------------------------------------------

func _run(thread:Thread) -> void:
    while true:
        _mutex.lock()
        if not _running:
            _mutex.unlock()
            break

        var next_task:Task = _tasks.pop_front() if not _tasks.is_empty() else null
        _mutex.unlock()

        if next_task:
            next_task.execute()
            emit_signal.call_deferred("on_task_completed")
        else:
            _semaphore.wait()
    _semaphore.post()

class Task extends RefCounted:
    var _callable:Callable
    var _promise:HPromise

    func _init(c:Callable) -> void:
        _callable = c
        _promise = HPromise.new()

    func execute() -> void:
        if _callable.is_valid():
            var result:Variant = _callable.call()
            _promise._resolve_later(result)
        else:
            _promise._reject_later()
