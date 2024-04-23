extends Node
# Autoload

##
## Utility to load scenes and instantiates nodes asynchronously.
##

#------------------------------------------
# Constants
#------------------------------------------

const DEFAULT_THREAD_POOL_SIZE:int = 1

#------------------------------------------
# Signals
#------------------------------------------

## Emitted when a scene starts loading asynchronously
signal on_scene_load_started(scene_path:String)
## Emitted when a scene is loading
signal on_scene_load_progress(scene_path:String, progress:float)
## Emitted when a scene loading is finished and is available
signal on_scene_load_finished(scene_path:String, scene:PackedScene)
## Emitted when a scene failed to load
signal on_scene_load_failed(scene_path:String)

## Emitted when scene instance has been created asynchronously and is available
signal on_scene_instantiation_finished(scene_path:String, scene_instance:Node)
## Emitted when scene instance failed to be created asynchronously
signal on_scene_instantiation_failed(scene_path:String)

#------------------------------------------
# Exports
#------------------------------------------

#------------------------------------------
# Public variables
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

# Scenes that are loading asynchronously
var _loading_scenes:Dictionary = {}
# Pool of threads to load scenes
var _thread_pool:HThreadPool = HThreadPool.new(DEFAULT_THREAD_POOL_SIZE, false)

#------------------------------------------
# Godot override functions
#------------------------------------------

func _process(delta: float) -> void:
    if _loading_scenes.is_empty():
        return

    for scene_path in _loading_scenes:
        var progress:Array = []
        var status:ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(scene_path, progress)
        match status:
            ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
                _handle_scene_loaded(scene_path)
            ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
                _handle_scene_load_in_progress(scene_path, progress[0])
            ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE:
                _handle_scene_load_failed(scene_path)
            ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
                _handle_scene_load_failed(scene_path)

#------------------------------------------
# Public functions
#------------------------------------------

## Immediatly load the given scene. Blocks until loading is finished.
func immediate_load_scene(scene_path:String) -> PackedScene:
    return ResourceLoader.load(scene_path)

## Trigger a scene load asynchronously. The loaded [PackedScene] can be obtain:[br]
## - using the [signal on_scene_load_finished] signal[br]
## - using the returned [HPromise] [signal HPromise.resolved] signal[br]
## This method does not block the current thread.
func async_load_scene(scene_path:String) -> HPromise:
    # Check if already loaded
    if ResourceLoader.load_threaded_get_status(scene_path) == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
        var scene:PackedScene = ResourceLoader.load_threaded_get(scene_path)
        var promise:HPromise = HPromise.new()
        promise._resolve_later(scene)
        emit_signal.call_deferred("on_scene_load_finished", scene_path, promise._result)
        return promise

    # If not, add it to loading scenes
    var promise:HPromise = HPromise.new()
    _loading_scenes[scene_path] = promise
    # Then start to load it
    ResourceLoader.load_threaded_request(scene_path)
    emit_signal.call_deferred("on_scene_load_started", scene_path)

    return promise

## Immediatly load and instantiate the given scene. Blocks until loading is finished.
func immediate_scene_instantiate(scene_path:String) -> Variant:
    return immediate_load_scene(scene_path).instantiate()

## Trigger a scene instantiation asynchronously. The instantiated scene can be obtained:[br]
## - using the [signal on_scene_instantiation_finished] signal[br]
## - using the returned [HPromise] [signal HPromise.resolved] signal[br]
## This method does not block the current thread.
func async_scene_instantiate(scene_path:String) -> HPromise:
    # We first need to async load the scene
    var scene_promise:HPromise = async_load_scene(scene_path)
    # Then, when it's ready, async instantiate the scene
    var instance_promise:HPromise = HPromise.new()
    scene_promise.rejected.connect(instance_promise._reject_immediatly)
    scene_promise.resolved.connect(_on_scene_loaded_ready_to_instantiate.bind(scene_path, instance_promise))
    return instance_promise

#------------------------------------------
# Private functions
#------------------------------------------

func _handle_scene_loaded(scene_path:String) -> void:
    var scene:PackedScene = ResourceLoader.load_threaded_get(scene_path)
    var promise:HPromise = _loading_scenes[scene_path]
    _loading_scenes.erase(scene_path)
    promise._resolve_later(scene)
    # Explicitly reference this promise in the referencer to avoid premature GC
    # If user did not store a reference to this promise and just connect to its signals,
    # then the promise can be GC before next frame
    HReferencer.register(promise, 1_000)
    emit_signal.call_deferred("on_scene_load_progress", scene_path, 1.0)
    emit_signal.call_deferred("on_scene_load_finished", scene_path, scene)

func _handle_scene_load_in_progress(scene_path:String, progress:float) -> void:
    emit_signal.call_deferred("on_scene_load_progress", scene_path, progress)

func _handle_scene_load_failed(scene_path:String) -> void:
    var promise:HPromise = _loading_scenes[scene_path]
    _loading_scenes.erase(scene_path)
    promise._reject_later()
    # Explicitly reference this promise in the referencer to avoid premature GC
    # If user did not store a reference to this promise and just connect to its signals,
    # then the promise can be GC before next frame
    HReferencer.register(promise, 1_000)
    emit_signal.call_deferred("on_scene_load_failed", scene_path)

func _on_scene_loaded_ready_to_instantiate(scene:PackedScene, scene_path:String, instance_promise:HPromise) -> void:
    # We have to wait for the task promise to be completed, then transfer its result into
    # the instance promise that has been given to the user
    var pool_promise:HPromise = _thread_pool.submit(scene.instantiate)
    pool_promise.rejected.connect(func():
        HReferencer.unregister(pool_promise)
        instance_promise._reject_immediatly()
        on_scene_instantiation_failed.emit())
    pool_promise.resolved.connect(func(res):
        HReferencer.unregister(pool_promise)
        instance_promise._resolve_immediatly(res)
        on_scene_instantiation_finished.emit(scene_path, res))

    # Since nobody maintains a reference to this promise, keep it in the referencer until it's completed
    HReferencer.register(pool_promise, 1_000_000)
