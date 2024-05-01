extends Node
class_name HGuiAnimator

##
## Utility node to animate multiple controls together to show/hide menus.
##

#------------------------------------------
# Constants
#------------------------------------------

const _META_SHOW_INITIALIZER:String = "__gui_animator_show_initializer__"
const _META_HIDE_RESETER:String = "__gui_animator_hide_reseter__"
const _META_SHOW_TWEEN:String = "__gui_animator_show_tween__"
const _META_HIDE_TWEEN:String = "__gui_animator_hide_tween__"

enum AnimationType {
    ## Animation the alpha channel of modulation to create fade effect
    FADE = 0,
    ## Scale up or down horizontaly and verticaly the control
    SCALE = 1,
    ## Scale up or down horizontaly the control
    SCALE_HORIZONTAL = 2,
    ## Scale up or down verticaly the control
    SCALE_VERTICAL = 3,
    ## Move to/from the left side of the screen the control
    SLIDE_LEFT = 4,
    ## Move to/from the right side of the screen the control
    SLIDE_RIGHT = 5,
    ## Move to/from the top side of the screen the control
    SLIDE_TOP = 6,
    ## Move to/from the bottom side of the screen the control
    SLIDE_BOTTOM = 7,
    ## Move to/from the top left side of the screen the control
    SLIDE_TOP_LEFT = 8,
    ## Move to/from the top right of the screen the control
    SLIDE_TOP_RIGHT = 9,
    ## Move to/from the bottom left side of the screen the control
    SLIDE_BOTTOM_LEFT = 10,
    ## Move to/from the bottom right side of the screen the control
    SLIDE_BOTTOM_RIGHT= 11
}

enum EaseType {
    ## The interpolation starts slowly and speeds up towards the end.
    EASE_IN = 0,
    ## The interpolation starts quickly and slows down towards the end.
    EASE_OUT = 1,
    ## A combination of [enum HTween.EaseType.EASE_IN] and [enum HTween.EaseType.EASE_OUT]. The interpolation is slowest at both ends.
    EASE_IN_OUT = 2,
    ## A combination of [enum HTween.EaseType.EASE_IN] and [enum HTween.EaseType.EASE_OUT]. The interpolation is fastest at both ends.
    EASE_OUT_IN = 3
}

enum TransitionType {
    ## The animation is interpolated linearly.
    TRANS_LINEAR = 0,
    ## The animation is interpolated using a sine function.
    TRANS_SINE = 1,
    ## The animation is interpolated with a quintic (to the power of 5) function.
    TRANS_QUINT = 2,
    ## The animation is interpolated with a quartic (to the power of 4) function.
    TRANS_QUART = 3,
    ## The animation is interpolated with a quadratic (to the power of 2) function.
    TRANS_QUAD = 4,
    ## The animation is interpolated with an exponential (to the power of x) function.
    TRANS_EXPO = 5,
    ## The animation is interpolated with elasticity, wiggling around the edges.
    TRANS_ELASTIC = 6,
    ## The animation is interpolated with a cubic (to the power of 3) function.
    TRANS_CUBIC = 7,
    ## The animation is interpolated with a function using square roots.
    TRANS_CIRC = 8,
    ## The animation is interpolated by bouncing at the end.
    TRANS_BOUNCE = 9,
    ## The animation is interpolated backing out at ends.
    TRANS_BACK = 10,
    ## The animation is interpolated like a spring towards the end.
    TRANS_SPRING = 11
}

#------------------------------------------
# Signals
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

@export var auto_start:bool = true

@export_category("Animation")
## Animation use to show controls
@export var show_animation:AnimationType = AnimationType.FADE
## Animation use to hide controls
@export var hide_animation:AnimationType = AnimationType.FADE
## Delay to way before starting the next control animation.
@export var delay_between_animations:float = 0.0
## Animation duration by control. If you animate 5 control with an animation duration set to [code]0.2[/code],
## the total animation time will be [code]1.0[/code] seconds.
@export var animation_duration:float = 0.4
## Transition type to apply to animations
@export var transition_type:TransitionType = TransitionType.TRANS_LINEAR
## Ease type to apply to animations
@export var ease_type:EaseType = EaseType.EASE_IN_OUT

@export_category("Controls")
## List of controls to animate. Control order is important since they will be animated on the same order
## as they appear in this array.
@export var controls:Array[Control]
## If [code]true[/code], the control pivot offset is override and set to its center. It's necessary
## for some animations like scales. If set to [code]false[/code], some animations may be broken.
@export var override_pivot_offset:bool = true

#------------------------------------------
# Public variables
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

#------------------------------------------
# Godot override functions
#------------------------------------------

func _ready() -> void:
    # Wait for one frame that all components are ready, since this node may be placed before
    # control nodes in hierarchy, so _ready is called to soon
    await get_tree().process_frame

    var max_animation_delay:float = delay_between_animations * (controls.size() - 1)
    for i in controls.size():
        _initialize_control_animation_behavior(controls[i], delay_between_animations * i, max_animation_delay)

    if auto_start:
        show()

#------------------------------------------
# Public functions
#------------------------------------------

## Show all controls with the programmed animation.
func show() -> void:
    for control in controls:
        # In case the hide action is processing, stop all !
        if control.get_meta(_META_HIDE_TWEEN).is_running():
            control.get_meta(_META_HIDE_TWEEN).stop()
        control.get_meta(_META_HIDE_RESETER).call()
        control.get_meta(_META_SHOW_INITIALIZER).call()
        control.get_meta(_META_SHOW_TWEEN).play()

## Hide all controls with the programmed animation.
func hide() -> void:
    #Just play all tweens, controls properties will just remain in current state
    for control in controls:
        control.get_meta(_META_HIDE_TWEEN).play()

#------------------------------------------
# Private functions
#------------------------------------------

func _initialize_control_animation_behavior(control:Control, delay:float, max_animation_delay:float) -> void:
    if override_pivot_offset:
        control.pivot_offset = control.size / 2

    _build_animation(control, delay, max_animation_delay, true, show_animation)
    _build_animation(control, delay, max_animation_delay, false, hide_animation)

func _build_animation(control:Control, delay:float, max_animation_delay:float, is_show:bool, anim_type:AnimationType) -> void:
    match anim_type:
        AnimationType.FADE:
            if is_show:
                _build_fade_in(control, delay)
            else:
                _build_fade_out(control, delay)
        AnimationType.SCALE:
            if is_show:
                _build_scale_in(control, delay)
            else:
                _build_scale_out(control, delay)
        AnimationType.SCALE_HORIZONTAL:
            if is_show:
                _build_scale_horizontal_in(control, delay)
            else:
                _build_scale_horizontal_out(control, delay)
        AnimationType.SCALE_VERTICAL:
            if is_show:
                _build_scale_vertical_in(control, delay)
            else:
                _build_scale_vertical_out(control, delay)
        AnimationType.SLIDE_LEFT:
            if is_show:
                _build_slide_left_in(control, delay)
            else:
                _build_slide_left_out(control, delay)
        AnimationType.SLIDE_RIGHT:
            if is_show:
                _build_slide_right_in(control, delay)
            else:
                _build_slide_right_out(control, delay)
        AnimationType.SLIDE_TOP:
            if is_show:
                _build_slide_top_in(control, delay, max_animation_delay)
            else:
                _build_slide_top_out(control, delay)
        AnimationType.SLIDE_BOTTOM:
            if is_show:
                _build_slide_bottom_in(control, delay)
            else:
                _build_slide_bottom_out(control, delay, max_animation_delay)
        AnimationType.SLIDE_TOP_LEFT:
            if is_show:
                _build_slide_top_left_in(control, delay, max_animation_delay)
            else:
                _build_slide_top_left_out(control, delay)
        AnimationType.SLIDE_TOP_RIGHT:
            if is_show:
                _build_slide_top_right_in(control, delay, max_animation_delay)
            else:
                _build_slide_top_right_out(control, delay)
        AnimationType.SLIDE_BOTTOM_LEFT:
            if is_show:
                _build_slide_bottom_left_in(control, delay)
            else:
                _build_slide_bottom_left_out(control, delay, max_animation_delay)
        AnimationType.SLIDE_BOTTOM_RIGHT:
            if is_show:
                _build_slide_bottom_right_in(control, delay)
            else:
                _build_slide_bottom_right_out(control, delay, max_animation_delay)

func _build_fade_in(control:Control, delay:float) -> void:
    control.set_meta(_META_SHOW_INITIALIZER, func(): control.modulate.a = 0.0)
    _create_tween(control, delay, _META_SHOW_TWEEN, func(step):
        return step.tween_property(control, "modulate:a", 1, animation_duration))

func _build_fade_out(control:Control, delay:float) -> void:
    control.set_meta(_META_HIDE_RESETER, func(): control.modulate.a = 1.0)
    _create_tween(control, delay, _META_HIDE_TWEEN, func(step):
        return step.tween_property(control, "modulate:a", 0, animation_duration))

func _build_scale_in(control:Control, delay:float) -> void:
    control.set_meta(_META_SHOW_INITIALIZER, func(): control.scale = Vector2.ZERO)
    _create_tween(control, delay, _META_SHOW_TWEEN, func(step):
        return step.tween_property(control, "scale", Vector2(1.0, 1.0), animation_duration))

func _build_scale_out(control:Control, delay:float) -> void:
    control.set_meta(_META_HIDE_RESETER, func(): control.scale = Vector2(1.0, 1.0))
    _create_tween(control, delay, _META_HIDE_TWEEN, func(step):
        return step.tween_property(control, "scale", Vector2.ZERO, animation_duration))

func _build_scale_horizontal_in(control:Control, delay:float) -> void:
    control.set_meta(_META_SHOW_INITIALIZER, func(): control.scale = Vector2(0.0, 1.0))
    _create_tween(control, delay, _META_SHOW_TWEEN, func(step):
        return step.tween_property(control, "scale", Vector2(1.0, 1.0), animation_duration))

func _build_scale_horizontal_out(control:Control, delay:float) -> void:
    control.set_meta(_META_HIDE_RESETER, func(): control.scale = Vector2(1.0, 1.0))
    _create_tween(control, delay, _META_HIDE_TWEEN, func(step):
        return step.tween_property(control, "scale", Vector2(0.0, 1.0), animation_duration))

func _build_scale_vertical_in(control:Control, delay:float) -> void:
    control.set_meta(_META_SHOW_INITIALIZER, func(): control.scale = Vector2(1.0, 0.0))
    _create_tween(control, delay, _META_SHOW_TWEEN, func(step):
        return step.tween_property(control, "scale", Vector2(1.0, 1.0), animation_duration))

func _build_scale_vertical_out(control:Control, delay:float) -> void:
    control.set_meta(_META_HIDE_RESETER, func(): control.scale = Vector2(1.0, 1.0))
    _create_tween(control, delay, _META_HIDE_TWEEN, func(step):
        return step.tween_property(control, "scale", Vector2(1.0, 0.0), animation_duration))

func _build_slide_left_in(control:Control, delay:float) -> void:
    var initial_position:Vector2 = control.global_position
    control.set_meta(_META_SHOW_INITIALIZER, func():
        control.global_position.x = -(get_viewport().size.x - initial_position.x) * 2 - control.size.x)
    _create_tween(control, delay, _META_SHOW_TWEEN, func(step):
        return step.tween_property(control, "global_position", initial_position, animation_duration))

func _build_slide_left_out(control:Control, delay:float) -> void:
    var initial_position:Vector2 = control.global_position
    control.set_meta(_META_HIDE_RESETER, func():
        control.global_position = initial_position)
    _create_tween(control, delay, _META_HIDE_TWEEN, func(step):
        return step.tween_property(control, "global_position:x", -(get_viewport().size.x - initial_position.x) * 2 - control.size.x, animation_duration))

func _build_slide_right_in(control:Control, delay:float) -> void:
    var initial_position:Vector2 = control.global_position
    control.set_meta(_META_SHOW_INITIALIZER, func():
        control.global_position.x = (get_viewport().size.x - initial_position.x) * 2 + control.size.x)
    _create_tween(control, delay, _META_SHOW_TWEEN, func(step):
        return step.tween_property(control, "global_position", initial_position, animation_duration))

func _build_slide_right_out(control:Control, delay:float) -> void:
    var initial_position:Vector2 = control.global_position
    control.set_meta(_META_HIDE_RESETER, func():
        control.global_position = initial_position)
    _create_tween(control, delay, _META_HIDE_TWEEN, func(step):
        return step.tween_property(control, "global_position:x", (get_viewport().size.x - initial_position.x) * 2 + control.size.x, animation_duration))

func _build_slide_top_in(control:Control, delay:float, max_animation_delay:float) -> void:
    var initial_position:Vector2 = control.global_position
    control.set_meta(_META_SHOW_INITIALIZER, func():
        control.global_position.y = -(get_viewport().size.y - initial_position.y) * 2 - control.size.y)
    _create_tween(control, max_animation_delay - delay, _META_SHOW_TWEEN, func(step):
        return step.tween_property(control, "global_position", initial_position, animation_duration))

func _build_slide_top_out(control:Control, delay:float) -> void:
    var initial_position:Vector2 = control.global_position
    control.set_meta(_META_HIDE_RESETER, func():
        control.global_position = initial_position)
    _create_tween(control, delay, _META_HIDE_TWEEN, func(step):
        return step.tween_property(control, "global_position:y", -(get_viewport().size.y - initial_position.y) * 2 - control.size.y, animation_duration))

func _build_slide_bottom_in(control:Control, delay:float) -> void:
    var initial_position:Vector2 = control.global_position
    control.set_meta(_META_SHOW_INITIALIZER, func():
        control.global_position.y = (get_viewport().size.y + initial_position.y) * 2 + control.size.y)
    _create_tween(control, delay, _META_SHOW_TWEEN, func(step):
        return step.tween_property(control, "global_position", initial_position, animation_duration))

func _build_slide_bottom_out(control:Control, delay:float, max_animation_delay:float) -> void:
    var initial_position:Vector2 = control.global_position
    control.set_meta(_META_HIDE_RESETER, func():
        control.global_position = initial_position)
    _create_tween(control, max_animation_delay - delay, _META_HIDE_TWEEN, func(step):
        return step.tween_property(control, "global_position:y", (get_viewport().size.y + initial_position.y) * 2 + control.size.y, animation_duration))

func _build_slide_top_left_in(control:Control, delay:float, max_animation_delay:float) -> void:
    var initial_position:Vector2 = control.global_position
    control.set_meta(_META_SHOW_INITIALIZER, func():
        control.global_position = -(Vector2(get_viewport().size) - initial_position) * 2 - control.size)
    _create_tween(control, max_animation_delay - delay, _META_SHOW_TWEEN, func(step):
        return step.tween_property(control, "global_position", initial_position, animation_duration))

func _build_slide_top_left_out(control:Control, delay:float) -> void:
    var initial_position:Vector2 = control.global_position
    control.set_meta(_META_HIDE_RESETER, func():
        control.global_position = initial_position)
    _create_tween(control, delay, _META_HIDE_TWEEN, func(step):
        return step.tween_property(control, "global_position", -(Vector2(get_viewport().size) - initial_position) * 2 - control.size, animation_duration))

func _build_slide_top_right_in(control:Control, delay:float, max_animation_delay:float) -> void:
    var initial_position:Vector2 = control.global_position
    var viewport:Viewport = get_viewport()
    control.set_meta(_META_SHOW_INITIALIZER, func():
        control.global_position = (Vector2(viewport.size.x, -viewport.size.y) + Vector2(initial_position.x, -initial_position.y)) * 2 + Vector2(control.size.x, -control.size.y))
    _create_tween(control, max_animation_delay - delay, _META_SHOW_TWEEN, func(step):
        return step.tween_property(control, "global_position", initial_position, animation_duration))

func _build_slide_top_right_out(control:Control, delay:float) -> void:
    var initial_position:Vector2 = control.global_position
    var viewport:Viewport = get_viewport()
    control.set_meta(_META_HIDE_RESETER, func():
        control.global_position = initial_position)
    _create_tween(control, delay, _META_HIDE_TWEEN, func(step):
        return step.tween_property(control, "global_position", (Vector2(viewport.size.x, -viewport.size.y) + Vector2(initial_position.x, -initial_position.y)) * 2 + Vector2(control.size.x, -control.size.y), animation_duration))

func _build_slide_bottom_left_in(control:Control, delay:float) -> void:
    var initial_position:Vector2 = control.global_position
    var viewport:Viewport = get_viewport()
    control.set_meta(_META_SHOW_INITIALIZER, func():
        control.global_position = (Vector2(-viewport.size.x, viewport.size.y) + Vector2(-initial_position.x, initial_position.y)) * 2 + Vector2(-control.size.x, control.size.y))
    _create_tween(control, delay, _META_SHOW_TWEEN, func(step):
        return step.tween_property(control, "global_position", initial_position, animation_duration))

func _build_slide_bottom_left_out(control:Control, delay:float, max_animation_delay:float) -> void:
    var initial_position:Vector2 = control.global_position
    var viewport:Viewport = get_viewport()
    control.set_meta(_META_HIDE_RESETER, func():
        control.global_position = initial_position)
    _create_tween(control, max_animation_delay - delay, _META_HIDE_TWEEN, func(step):
        return step.tween_property(control, "global_position", (Vector2(-viewport.size.x, viewport.size.y) + Vector2(-initial_position.x, initial_position.y)) * 2 + Vector2(-control.size.x, control.size.y), animation_duration))

func _build_slide_bottom_right_in(control:Control, delay:float) -> void:
    var initial_position:Vector2 = control.global_position
    control.set_meta(_META_SHOW_INITIALIZER, func():
        control.global_position = (Vector2(get_viewport().size) + initial_position) * 2 + control.size)
    _create_tween(control, delay, _META_SHOW_TWEEN, func(step):
        return step.tween_property(control, "global_position", initial_position, animation_duration))

func _build_slide_bottom_right_out(control:Control, delay:float, max_animation_delay:float) -> void:
    var initial_position:Vector2 = control.global_position
    control.set_meta(_META_HIDE_RESETER, func():
        control.global_position = initial_position)
    _create_tween(control, max_animation_delay - delay, _META_HIDE_TWEEN, func(step):
        return step.tween_property(control, "global_position", (Vector2(get_viewport().size) + initial_position) * 2 + control.size, animation_duration))

func _create_tween(control:Control, delay:float, meta_prop:String, animator_callable:Callable) -> void:
    var interval_builder:HTweenAnimationIntervalBuilder = HTweenBuilder.build_tween(control) \
        .manual_start() \
        .default_trans(HTween.TransitionType.get(TransitionType.keys()[transition_type])) \
        .default_ease(HTween.EaseType.get(EaseType.keys()[ease_type])) \
        .new_step() \
            .tween_interval(delay)
    control.set_meta(meta_prop, animator_callable.call(interval_builder).build())
