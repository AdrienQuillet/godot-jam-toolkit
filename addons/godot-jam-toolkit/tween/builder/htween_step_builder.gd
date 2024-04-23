extends RefCounted
class_name HTweenStepBuilder

##
## Utility class to build [HTweenStep] from code. See [HTweenBuilder].
##

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

var _step:HTweenStep
var _builder:HTweenBuilder

#------------------------------------------
# Godot override functions
#------------------------------------------

func _init(builder:HTweenBuilder, parallel:bool, human_desc:String) -> void:
    _builder = builder
    _step = HTweenStep.new()
    _step.parallel = parallel
    _step.name = human_desc

#------------------------------------------
# Public functions
#------------------------------------------

static func build_step(builder:HTweenBuilder, parallel:bool, human_desc:String) -> HTweenStepBuilder:
    return HTweenStepBuilder.new(builder, parallel, human_desc)

func tween_callable(callable:Callable) -> HTweenAnimationCallableBuilder:
    return HTweenAnimationCallableBuilder.create(self, callable)

func tween_interval(time:float) -> HTweenAnimationIntervalBuilder:
    return HTweenAnimationIntervalBuilder.create(self, time)

func tween_method(callable:Callable, from_value:Variant, to_value:Variant, duration:float) -> HTweenAnimationMethodBuilder:
    return HTweenAnimationMethodBuilder.create(self, callable, from_value, to_value, duration)

func tween_property(object:Variant, property:String, final_value:Variant, duration:float) -> HTweenAnimationPropertyBuilder:
    return HTweenAnimationPropertyBuilder.create(self, object, property, final_value, duration)

func new_step(parallel:bool = false, human_desc:String = "") -> HTweenStepBuilder:
    return _internal_build().new_step(parallel, human_desc)

func build() -> HTween:
    return _internal_build().build()

#------------------------------------------
# Private functions
#------------------------------------------

func _internal_build() -> HTweenBuilder:
    _builder._tween.steps.append(_step)
    return _builder
