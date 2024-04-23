extends HTweenAnimationBuilder
class_name HTweenAnimationCallableBuilder

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

func _init(step_builder:HTweenStepBuilder, callable:Callable) -> void:
    _step_builder = step_builder
    _animation.animation_type = HTween.AnimationType.CALLBACK
    _animation._callback_callable = callable

#------------------------------------------
# Public functions
#------------------------------------------

static func create(step_builder:HTweenStepBuilder, callable:Callable) -> HTweenAnimationCallableBuilder:
    return HTweenAnimationCallableBuilder.new(step_builder, callable)

func speed_scale(scale:float) -> HTweenAnimationCallableBuilder:
    _animation.speed_scale = scale
    return self

func delay(delay:float) -> HTweenAnimationCallableBuilder:
    _animation.callback_delay = delay
    return self

#------------------------------------------
# Private functions
#------------------------------------------

