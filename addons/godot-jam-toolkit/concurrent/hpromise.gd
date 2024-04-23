extends RefCounted
class_name HPromise

##
## The Promise object represents the eventual completion (or failure) of an asynchronous operation
## and its resulting value.
##

#------------------------------------------
# Constants
#------------------------------------------

#------------------------------------------
# Signals
#------------------------------------------

## Emitted when the promise has been resolved, [i]i.e.[/i] the related task is completed and
## its result is available
signal resolved(result:Variant)

## Emitted when the promise has been rejected, [i]i.e.[/i] the related task has been cancelled
## or has failed
signal rejected

#------------------------------------------
# Exports
#------------------------------------------

#------------------------------------------
# Public variables
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

# Result when resolved
var _resolved:Variant
# If this promise has been resolved
var _is_resolved:bool = false
# If this promise has been rejected
var _is_rejected:bool = false

#------------------------------------------
# Godot override functions
#------------------------------------------

#------------------------------------------
# Public functions
#------------------------------------------

## Returns [code]true[/code] if this promise has been resolved, [code]false[/code] otherwise. If
## the promise is resolved, calling [method HPromise.get_resolved_value] will returned the resolved
## value.
func is_resolved() -> bool:
    return _is_resolved

## Returns [code]true[/code] if this promise has been rejected, [code]false[/code] otherwise. If rejected,
## calling [method HPromise.get_resolved_value] will always return [code]null[/code].
func is_rejected() -> bool:
    return _is_rejected

## Returns the resolved value is this promise is resolved, or [code]null[/code] if this promise is not
## yet resolved or is rejected.
func get_resolved_value() -> Variant:
    return _resolved

#------------------------------------------
# Private functions
#------------------------------------------

func _resolve_immediatly(res:Variant) -> void:
    _is_resolved = true
    _resolved = res
    resolved.emit(_resolved)

func _reject_immediatly() -> void:
    _is_rejected = true
    rejected.emit()

func _resolve_later(res:Variant) -> void:
    _resolve_immediatly.call_deferred(res)

func _reject_later() -> void:
    _reject_immediatly.call_deferred()
