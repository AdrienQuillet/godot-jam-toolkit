extends Node
class_name HReferencer

##
## Utility to maintain references on objects for some times, avoiding them to be garbage collected.
##

#------------------------------------------
# Constants
#------------------------------------------

## Default eviction check delay. See [method set_check_delay] to change the actual value.
const DEFAULT_CHECK_DELAY_S:float = 0.3

#------------------------------------------
# Signals
#------------------------------------------

## Emitted when an object is registered in the referencer
signal on_registered(object:Variant, expires_at:float)

## Emitted when an object is evicted from the referencer due to expiration
signal on_eviction(evicted_object:Variant)

#------------------------------------------
# Exports
#------------------------------------------

#------------------------------------------
# Public variables
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

# Deay between eviction checks
var _check_delay:float = DEFAULT_CHECK_DELAY_S
# Time ellapsed from last eviction check
var _ellapsed_time_since_last_check:float = 0
# Registered objects and their expiration date
var _registered_objects:Dictionary = {}

#------------------------------------------
# Godot override functions
#------------------------------------------

func _process(delta: float) -> void:
    _ellapsed_time_since_last_check += delta
    if _ellapsed_time_since_last_check >= _check_delay:
        _ellapsed_time_since_last_check = 0
        _check_for_eviction()

#------------------------------------------
# Public functions
#------------------------------------------

## Set the delay between eviction checks. Shorter delays tends to evict objects faster, but
## depending on registered object count, it can be costly
func set_check_delay(delay:float) -> void:
    _check_delay = max(0.05, delay)

## Register an object and it's expiration time, in seconds. This object is guarantee to be
## registered at least for the expected time.
## [br]
## If object is already registered, this call will update its expiration time
func register(object:Variant, expires_in:float) -> void:
    if object != null:
        var expires_at:float = Time.get_ticks_msec() + 1_000 * max(0, expires_in)
        _registered_objects[object] = expires_at
        emit_signal.call_deferred("on_registered", object, expires_at)

## Unregister an object immediatly, before it's expiration
func unregister(object:Variant) -> void:
    var expiration_time = _registered_objects.erase(object)
    if expiration_time:
        emit_signal.call_deferred("on_eviction", object)

#------------------------------------------
# Private functions
#------------------------------------------

func _check_for_eviction() -> void:
    if _registered_objects.is_empty():
        return

    var now:float = Time.get_ticks_msec()
    for expiration_time in _registered_objects.values():
        if expiration_time <= now:
            var object:Variant = _registered_objects.find_key(expiration_time)
            _registered_objects.erase(object)
            emit_signal.call_deferred("on_eviction", object)

