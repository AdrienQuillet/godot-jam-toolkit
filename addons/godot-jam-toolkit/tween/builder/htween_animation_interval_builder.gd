extends HTweenAnimationBuilder
class_name HTweenAnimationIntervalBuilder

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

func _init(step_builder:HTweenStepBuilder, time:float) -> void:
    _step_builder = step_builder
    _animation.animation_type = HTween.AnimationType.INTERVAL
    _animation.interval_time = time

#------------------------------------------
# Public functions
#------------------------------------------

static func create(step_builder:HTweenStepBuilder, time:float) -> HTweenAnimationIntervalBuilder:
    return HTweenAnimationIntervalBuilder.new(step_builder, time)

func speed_scale(scale:float) -> HTweenAnimationIntervalBuilder:
    _animation.speed_scale = scale
    return self

#------------------------------------------
# Private functions
#------------------------------------------

