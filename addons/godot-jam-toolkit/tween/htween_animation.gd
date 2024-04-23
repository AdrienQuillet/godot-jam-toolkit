@tool
extends Resource
class_name HTweenAnimation

#------------------------------------------
# Constants
#------------------------------------------

#------------------------------------------
# Signals
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

@export var animation_type:HTween.AnimationType:
    set(value):
        if animation_type != value:
            animation_type = value
            property_list_changed.emit()
            emit_changed()

@export var speed_scale:float = 1.0:
    set(value):
        if speed_scale != value:
            speed_scale = value
            emit_changed()

@export_group("Callback", "callback_")
@export var callback_object:NodePath:
    set(value):
        if callback_object != value:
            callback_object = value
            emit_changed()
@export var callback_method:String:
    set(value):
        if callback_method != value:
            callback_method = value
            emit_changed()
@export var callback_binds:Array[Variant]:
    set(value):
        if callback_binds != value:
            callback_binds = value
            emit_changed()
@export var callback_delay:float = 0.0:
    set(value):
        if callback_delay != value:
            callback_delay = value
            emit_changed()

@export_group("Interval", "interval_")
@export var interval_time:float:
    set(value):
        if interval_time != value:
            interval_time = value
            emit_changed()

@export_group("Method", "method_")
@export var method_object:NodePath:
    set(value):
        if method_object != value:
            method_object = value
            emit_changed()
@export var method_method:String:
    set(value):
        if method_method != value:
            method_method = value
            emit_changed()
@export var method_binds:Array[Variant]:
    set(value):
        if method_binds != value:
            method_binds = value
            emit_changed()
@export var method_from_value:String:
    set(value):
        if method_from_value != value:
            method_from_value = value
            emit_changed()
@export var method_to_value:String:
    set(value):
        if method_to_value != value:
            method_to_value = value
            emit_changed()
@export var method_duration:float:
    set(value):
        if method_duration != value:
            method_duration = max(0, value)
            emit_changed()
@export var method_delay:float = 0.0:
    set(value):
        if method_delay != value:
            method_delay = value
            emit_changed()
@export var method_ease:HTween.EaseType = HTween.EaseType.INHERIT:
    set(value):
        if method_ease != value:
            method_ease = value
            emit_changed()
@export var method_trans:HTween.TransitionType = HTween.TransitionType.INHERIT:
    set(value):
        if method_trans != value:
            method_trans = value
            emit_changed()

@export_group("Property", "property_")
@export var property_object:NodePath:
    set(value):
        if property_object != value:
            property_object = value
            emit_changed()
@export var property_property:String:
    set(value):
        if property_property != value:
            property_property = value
            emit_changed()
@export var property_final_value:String:
    set(value):
        if property_final_value != value:
            property_final_value = value
            emit_changed()
@export var property_duration:float:
    set(value):
        if property_duration != value:
            property_duration = max(0, value)
            emit_changed()
@export var property_as_relative:bool:
    set(value):
        if property_as_relative != value:
            property_as_relative = value
            emit_changed()
@export var property_delay:float = 0.0:
    set(value):
        if property_delay != value:
            property_delay = value
            emit_changed()
@export var property_ease:HTween.EaseType = HTween.EaseType.INHERIT:
    set(value):
        if property_ease != value:
            property_ease = value
            emit_changed()
@export var property_trans:HTween.TransitionType = HTween.TransitionType.INHERIT:
    set(value):
        if property_trans != value:
            property_trans = value
            emit_changed()

#------------------------------------------
# Public variables
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

# Internal usage with builder, since most callable from code do no concern Node
var _callback_callable
# Internal usage with builder, since most callable from code do no concern Node
var _method_callable
# Internal usage with builder, since most callable from code do no concern Node
var _property_object

#------------------------------------------
# Godot override functions
#------------------------------------------

func _validate_property(property: Dictionary) -> void:
    var prefixes:Array[String] = [ "callback", "interval", "method", "property" ]
    match animation_type:
        HTween.AnimationType.CALLBACK:
            prefixes.erase("callback")
        HTween.AnimationType.INTERVAL:
            prefixes.erase("interval")
        HTween.AnimationType.METHOD:
            prefixes.erase("method")
        HTween.AnimationType.PROPERTY:
            prefixes.erase("property")
    for prefix in prefixes:
        if not property.has("original_usage"):
            property.original_usage = property.usage

        if property.name.to_lower().begins_with(prefix):
            property.usage = PROPERTY_USAGE_NO_EDITOR
            break
        else:
            property.usage = property.original_usage

#------------------------------------------
# Public functions
#------------------------------------------

#------------------------------------------
# Private functions
#------------------------------------------
