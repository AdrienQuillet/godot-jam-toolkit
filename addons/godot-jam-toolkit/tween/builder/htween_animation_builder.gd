extends RefCounted
class_name HTweenAnimationBuilder
# Abstract

#------------------------------------------
# Constants
#------------------------------------------

#------------------------------------------
# Signals
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

#------------------------------------------
# Public variables
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

var _animation:HTweenAnimation = HTweenAnimation.new()
var _step_builder:HTweenStepBuilder

#------------------------------------------
# Godot override functions
#------------------------------------------

#------------------------------------------
# Public functions
#------------------------------------------

func new_step(parallel:bool = false, human_desc:String = "") -> HTweenStepBuilder:
    return _internal_build().new_step(parallel, human_desc)

func tween_callable(callable:Callable) -> HTweenAnimationCallableBuilder:
    return _internal_build().tween_callable(callable)

func tween_interval(time:float) -> HTweenAnimationIntervalBuilder:
    return _internal_build().tween_interval(time)

func tween_method(callable:Callable, from_value:Variant, to_value:Variant, duration:float) -> HTweenAnimationMethodBuilder:
    return _internal_build().tween_method(callable, from_value, to_value, duration)

func tween_property(object:Variant, property:String, final_value:Variant, duration:float) -> HTweenAnimationPropertyBuilder:
    return _internal_build().tween_property(object, property, final_value, duration)

func build() -> HTween:
    return _internal_build()._internal_build().build()

#------------------------------------------
# Private functions
#------------------------------------------

func _internal_build() -> HTweenStepBuilder:
    _step_builder._step.animations.append(_animation)
    return _step_builder
