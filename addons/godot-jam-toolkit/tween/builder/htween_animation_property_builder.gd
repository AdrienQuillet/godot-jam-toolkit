extends HTweenAnimationBuilder
class_name HTweenAnimationPropertyBuilder

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

func _init(step_builder:HTweenStepBuilder, object:Variant, property:String, final_value:Variant, duration:float) -> void:
    _step_builder = step_builder
    _animation.animation_type = HTween.AnimationType.PROPERTY
    _animation._property_object = object
    _animation.property_property = property
    _animation.property_final_value = var_to_str(final_value)
    _animation.property_duration = duration

#------------------------------------------
# Public functions
#------------------------------------------

static func create(step_builder:HTweenStepBuilder, object:Variant, property:String, final_value:Variant, duration:float) -> HTweenAnimationPropertyBuilder:
    return HTweenAnimationPropertyBuilder.new(step_builder, object, property, final_value, duration)

func speed_scale(scale:float) -> HTweenAnimationPropertyBuilder:
    _animation.speed_scale = scale
    return self

func delay(delay:float) -> HTweenAnimationPropertyBuilder:
    _animation.property_delay = delay
    return self

func ease(ease:HTween.EaseType) -> HTweenAnimationPropertyBuilder:
    _animation.property_ease = ease
    return self

func trans(trans:HTween.TransitionType) -> HTweenAnimationPropertyBuilder:
    _animation.property_trans = trans
    return self

func as_relative() -> HTweenAnimationPropertyBuilder:
    _animation.property_as_relative = true
    return self

#------------------------------------------
# Private functions
#------------------------------------------

