extends HTweenAnimationBuilder
class_name HTweenAnimationMethodBuilder

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

#------------------------------------------
# Godot override functions
#------------------------------------------

func _init(step_builder:HTweenStepBuilder, callable:Callable, from_value:Variant, to_value:Variant, duration:float) -> void:
    _step_builder = step_builder
    _animation.animation_type = HTween.AnimationType.METHOD
    _animation._method_callable = callable
    _animation.method_from_value = var_to_str(from_value)
    _animation.method_to_value = var_to_str(to_value)
    _animation.method_duration = duration

#------------------------------------------
# Public functions
#------------------------------------------

static func create(step_builder:HTweenStepBuilder, callable:Callable, from_value:Variant, to_value:Variant, duration:float) -> HTweenAnimationMethodBuilder:
    return HTweenAnimationMethodBuilder.new(step_builder, callable, from_value, to_value, duration)

func speed_scale(scale:float) -> HTweenAnimationMethodBuilder:
    _animation.speed_scale = scale
    return self

func delay(delay:float) -> HTweenAnimationMethodBuilder:
    _animation.method_delay = delay
    return self

func ease(ease:HTween.EaseType) -> HTweenAnimationMethodBuilder:
    _animation.method_ease = ease
    return self

func trans(trans:HTween.TransitionType) -> HTweenAnimationMethodBuilder:
    _animation.method_trans = trans
    return self

#------------------------------------------
# Private functions
#------------------------------------------

