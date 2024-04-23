@tool
extends Node
class_name HTween

##
## Lightweight object used for general-purpose animation via the Godot Editor.
##

#------------------------------------------
# Constants
#------------------------------------------

enum ConfigurationMode {
    ## Configure this tween for a single animation
    SINGLE = 0,
    ## Configure this tween for complex animations
    ADVANCED = 1
}

enum LoopMode {
    ## No loop
    NONE = 0,
    ## Tween will loop
    LOOP = 1
}

enum AnimationType {
    ## Use a [CallbackTweener]
    CALLBACK = 0,
    ## Use a [IntervalTweener]
    INTERVAL = 1,
    ## Use a [MethodTweener]
    METHOD = 2,
    ## Use a [PropertyTweener]
    PROPERTY = 3
}

enum EaseType {
    ## The interpolation starts slowly and speeds up towards the end.
    EASE_IN = 0,
    ## The interpolation starts quickly and slows down towards the end.
    EASE_OUT = 1,
    ## A combination of [enum HTween.EaseType.EASE_IN] and [enum HTween.EaseType.EASE_OUT]. The interpolation is slowest at both ends.
    EASE_IN_OUT = 2,
    ## A combination of [enum HTween.EaseType.EASE_IN] and [enum HTween.EaseType.EASE_OUT]. The interpolation is fastest at both ends.
    EASE_OUT_IN = 3,
    ## The animation uses default tween interpolation.
    INHERIT = 4
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
    TRANS_SPRING = 11,
    ## The animation uses default tween transition.
    INHERIT = 12
}

enum TweenProcessMode {
    ## The Tween updates after each physics frame.
    TWEEN_PROCESS_PHYSICS = 0,
    ## The Tween updates after each process frame
    TWEEN_PROCESS_IDLE = 1
}

enum TweenPauseMode {
    ## If the Tween has a bound node, it will process when that node can process
    ## Otherwise it's the same as [enum HTween.TweenPauseMode.TWEEN_PAUSE_STOP]
    TWEEN_PAUSE_BOUND = 0,
    ## If [SceneTree] is paused, the Tween will also pause.
    TWEEN_PAUSE_STOP = 1,
    ## The Tween will process regardless of whether [SceneTree] is paused.
    TWEEN_PAUSE_PROCESS = 2
}

#------------------------------------------
# Signals
#------------------------------------------

## Emitted when the Tween has finished all tweening.
## Never emitted when the Tween is set to infinite looping
signal finished
## Emitted when a full loop is complete, providing the loop index.
## This signal is not emitted after the final loop, use finished instead for this case.
signal loop_finished(loop_count:int)

#------------------------------------------
# Exports
#------------------------------------------

@export_category("Tween Configuration")
## If [code]true[/code], tween will start automatically when added to the [SceneTree].
## Otherwise, it will need to be started manualle (see [method HTween.play])
@export var autostart:bool = true

@export_category("Tween Animation")
## Change tween configuration
## [br][br]
## - [code]ConfigurationMode.SINGLE[/code]: configure this teen for a single animation. See [member HTween.animation].
## [br]
## - [code]ConfigurationMode.ADVANCED[/code]: configure this teen complex animations. See [member HTween.steps].
@export var configuration_mode:ConfigurationMode = ConfigurationMode.SINGLE:
    set(value):
        if configuration_mode != value:
            configuration_mode = value
            notify_property_list_changed()

## Tween loop mode
## [br][br]
## - [code]LoopMode.NONE[/code]: tween will be played only onced.
## [br]
## - [code]LoopMode.LOOP[/code]: tween will be played multiple times. See [HTween.loop_count].
@export var loop_mode:LoopMode = LoopMode.NONE:
    set(value):
        loop_mode = value
        notify_property_list_changed()

## Set number of time this tween will loop. [code]0[/code] loops indefinitely.
## Only useful in when [member HTween.loop_mode] is set to [code]LoopMode.LOOP[/code].
@export_range(0, 99999999) var loop_count:int = 0

## The animation to configure for this tween.
## Only useful in when [member HTween.configuration_mode] is set to [code]ConfigurationMode.SINGLE[/code].
@export var animation:HTweenAnimation = HTweenAnimation.new():
    set(value):
        if value != animation:
            if animation.changed.is_connected(_validate_tween):
                animation.changed.disconnect(_validate_tween)
            if value == null:
                value = HTweenAnimation.new()
            animation = value
            animation.changed.connect(_validate_tween)

## All tween animations, group by steps.
## Only useful in when [member HTween.configuration_mode] is set to [code]ConfigurationMode.ADVANCED[/code].
@export var steps:Array[HTweenStep]:
    set(value):
        if value == steps:
            return
        for old_step in steps:
            if old_step != null:
                if old_step.changed.is_connected(_validate_tween):
                    old_step.changed.disconnect(_validate_tween)
        steps = value
        if steps != null:
            for i in steps.size():
                if steps[i] == null:
                    steps[i] = HTweenStep.new()
                steps[i].changed.connect(_validate_tween)

## Sets the default ease type for [PropertyTweeners] and [MethodTweeners] animated by this tween.
## If not specified, the default value is [enum HTween.EaseType.EASE_IN_OUT].
@export var ease:EaseType = EaseType.EASE_IN_OUT
## Sets the default transition  type for [PropertyTweeners] and [MethodTweeners] animated by this tween.
## If not specified, the default value is [enum HTween.TransitionType.TRANS_LINEAR].
@export var trans:TransitionType = TransitionType.TRANS_LINEAR

@export_category("Tween Process")
## Determines whether the tween should run after process frames or physics frames.
## If not specified, the default value is [enum HTween.TweenProcessMode.TWEEN_PROCESS_IDLE].
@export var tween_process_mode:TweenProcessMode = TweenProcessMode.TWEEN_PROCESS_IDLE

@export_category("Tween Pause")
## Determines the behavior of the tween when the [SceneTree] is paused.
## If not specified, the default value is [enum HTween.TweenPauseMode.TWEEN_PAUSE_BOUND].
@export var tween_pause_mode:TweenPauseMode = TweenPauseMode.TWEEN_PAUSE_BOUND

#------------------------------------------
# Public variables
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

var _internal_tween:Tween
var _loop:int = -1

#------------------------------------------
# Godot override functions
#------------------------------------------

func _ready() -> void:
    if Engine.is_editor_hint():
        return

    if autostart:
        _internal_tween = _create_internal_tween()

func _validate_property(property: Dictionary) -> void:
    if not property.has("original_usage"):
            property.original_usage = property.usage

    if property.name.to_lower().begins_with("process_thread") or property.name.to_lower().begins_with("process"):
        property.usage = PROPERTY_USAGE_NO_EDITOR

    var anim_properties:PackedStringArray = [ "animation", "steps"]
    if property.name in anim_properties:
        if configuration_mode == ConfigurationMode.SINGLE:
            if property.name != "animation":
                property.usage = PROPERTY_USAGE_NO_EDITOR
            else:
                property.usage = property.original_usage
        else:
            if property.name == "animation":
                property.usage = PROPERTY_USAGE_NO_EDITOR
            else:
                property.usage = property.original_usage

    if property.name == "loop_count":
        if loop_mode == LoopMode.NONE:
            property.usage = PROPERTY_USAGE_NO_EDITOR
        else:
            property.usage = property.original_usage

func _get_configuration_warnings() -> PackedStringArray:
    if configuration_mode == ConfigurationMode.SINGLE:
        return _validate_single_tween()
    else:
        return _validate_advanced_tween()

#------------------------------------------
# Public functions
#------------------------------------------

## Starts or resume a paused or stopped tween.
func play() -> void:
    if _internal_tween == null or not _internal_tween.is_valid():
        _internal_tween = _create_internal_tween()
    else:
        _internal_tween.play()

## Pauses the tweening. The animation can be resumed by using [method HTween.play].
func pause() -> void:
    assert(_internal_tween != null, "Internal tween not created")
    _internal_tween.pause()

## Stops the tweening and resets the Tween to its initial state. This will not remove any appended Tweeners.
func stop() -> void:
    assert(_internal_tween != null, "Internal tween not created")
    _internal_tween.stop()

## Aborts all tweening operations and invalidates the tween.
func kill() -> void:
    assert(_internal_tween != null, "Internal tween not created")
    _dispose_internal_tween()

## Returns the number of remaining loops for this Tween (see [member HTween.loop_count]). A return value of
## [code]-1[/code] indicates an infinitely looping Tween, and a return value of
## [code]0[/code] indicates that the Tween has already finished.
func get_loops_left() -> int:
    assert(_internal_tween != null, "Internal tween not created")
    return  _internal_tween.get_loops_left()

#------------------------------------------
# Private functions
#------------------------------------------

func _validate_tween() -> void:
    if not Engine.is_editor_hint():
        return
    update_configuration_warnings()

func _validate_single_tween() -> PackedStringArray:
    return _validate_animation(animation)

func _validate_advanced_tween() -> PackedStringArray:
    var warnings:PackedStringArray = []
    return warnings

func _validate_animation(animation:HTweenAnimation) -> PackedStringArray:
    match animation.animation_type:
        AnimationType.CALLBACK:
            return _validate_callback_animation(animation)
        AnimationType.METHOD:
            return _validate_method_animation(animation)
        AnimationType.PROPERTY:
            return _validate_property_animation(animation)

    return PackedStringArray()

func _validate_callback_animation(animation:HTweenAnimation) -> PackedStringArray:
    if animation.callback_object.is_empty():
        return [ "Node path is mandatory" ]

    var node:Node = get_node_or_null(animation.callback_object)
    if node == null:
        return [ "% is not a valid node path" % animation.property_object ]

    if animation.callback_method.strip_edges().is_empty():
        return [ "Method name is mandatory" ]

    if not node.has_method(animation.callback_method):
        return [ "%s is not a valid method in node %s (%s)" % [animation.method_method, node.name, node.get_class()] ]

    return []

func _validate_method_animation(animation:HTweenAnimation) -> PackedStringArray:
    if animation.method_object.is_empty():
        return [ "Node path is mandatory" ]

    var node:Node = get_node_or_null(animation.method_object)
    if node == null:
        return [ "% is not a valid node path" % animation.property_object ]

    if animation.method_method.strip_edges().is_empty():
        return [ "Method name is mandatory" ]

    if not node.has_method(animation.method_method):
        return [ "%s is not a valid method in node %s (%s)" % [animation.method_method, node.name, node.get_class()] ]

    if animation.method_from_value.strip_edges().is_empty():
        return [ "From value is mandatory" ]

    if not _is_valid_expression(animation.method_from_value):
        return [ "%s is not a valid expression" % animation.method_from_value ]

    if animation.method_to_value.strip_edges().is_empty():
        return [ "To value is mandatory" ]

    if not _is_valid_expression(animation.method_to_value):
        return [ "%s is not a valid expression" % animation.method_to_value ]

    return []

func _validate_property_animation(animation:HTweenAnimation) -> PackedStringArray:
    if animation.property_object.is_empty():
        return [ "Node path is mandatory" ]

    var node:Node = get_node_or_null(animation.property_object)
    if node == null:
        return [ "% is not a valid node path" % animation.property_object ]

    if animation.property_property.strip_edges().is_empty():
        return [ "Property name is mandatory" ]

    if node.get_indexed(animation.property_property) == null:
        return [ "%s is not a valid property path in node %s (%s)" % [animation.property_property, node.name, node.get_class()] ]

    if animation.property_final_value.strip_edges().is_empty():
        return [ "Final value is mandatory" ]

    if not _is_valid_expression(animation.property_final_value):
        return [ "%s is not a valid expression" % animation.property_final_value ]

    return []

func _create_internal_tween() -> Tween:
    var tween:Tween = create_tween() # attached to this node

    if configuration_mode == ConfigurationMode.SINGLE:
        _populate_animation(tween, animation)
    else:
        for step in steps:
            _populate_step(tween, step)

    tween.set_process_mode(_convert_process_mode(tween_process_mode))
    tween.set_pause_mode(_convert_pause_mode(tween_pause_mode))
    if loop_mode == LoopMode.LOOP:
        tween.set_loops(loop_count)

    tween.finished.connect(_on_internal_tween_finished)
    tween.loop_finished.connect(_on_internal_tween_loop_finished)

    return tween

func _dispose_internal_tween() -> void:
    if _internal_tween:
        _internal_tween.stop()
        _internal_tween.kill()
        _internal_tween.finished.disconnect(_on_internal_tween_finished)
        _internal_tween.loop_finished.disconnect(_on_internal_tween_loop_finished)
        _internal_tween = null

func _populate_step(tween:Tween, step:HTweenStep) -> void:
    for anim_index in step.animations.size():
        var animation:HTweenAnimation = step.animations[anim_index]
        if not step.parallel or anim_index == 0:
            tween = tween.chain()
        else:
            tween = tween.parallel()
        _populate_animation(tween, animation)

func _populate_animation(tween:Tween, animation:HTweenAnimation) -> void:
    match animation.animation_type:
        AnimationType.CALLBACK:
            _populate_callback_tweener(tween, animation)
        AnimationType.INTERVAL:
            _populate_interval_tweener(tween, animation)
        AnimationType.METHOD:
            _populate_method_tweener(tween, animation)
        AnimationType.PROPERTY:
            _populate_property_tweener(tween, animation)

func _populate_callback_tweener(tween:Tween, animation:HTweenAnimation) -> void:
    var callable:Callable
    if animation._callback_callable != null:
        callable = animation._callback_callable
    else:
        callable = Callable(get_node(animation.callback_object), animation.callback_method)
        if not animation.callback_binds.is_empty():
            callable = callable.bindv(animation.callback_binds)
    tween.tween_callback(callable) \
        .set_delay(animation.callback_delay)

func _populate_interval_tweener(tween:Tween, animation:HTweenAnimation) -> void:
    tween.tween_interval(animation.interval_time)

func _populate_method_tweener(tween:Tween, animation:HTweenAnimation) -> void:
    var callable:Callable
    if animation._method_callable != null:
        callable = animation._method_callable
    else:
        callable = Callable(get_node(animation.method_object), animation.method_method)
        if not animation.method_binds.is_empty():
            callable = callable.bindv(animation.method_binds)
    var tweener:MethodTweener = tween.tween_method(callable, str_to_var(animation.method_from_value), str_to_var(animation.method_to_value), animation.method_duration)
    tweener.set_delay(animation.property_delay)
    tweener.set_ease(_convert_ease(ease) if animation.property_ease == EaseType.INHERIT else _convert_ease(animation.property_ease))
    tweener.set_trans(_convert_trans(trans) if animation.property_trans == TransitionType.INHERIT else _convert_trans(animation.property_trans))
    if animation.property_as_relative:
        tweener.as_relative()

func _populate_property_tweener(tween:Tween, animation:HTweenAnimation) -> void:
    var object:Object
    if animation._property_object != null:
        object = animation._property_object
    else:
        object = get_node(animation.property_object)
    var tweener:PropertyTweener = tween.tween_property(object, animation.property_property, str_to_var(animation.property_final_value), animation.property_duration)
    tweener.set_delay(animation.property_delay)
    tweener.set_ease(_convert_ease(ease) if animation.property_ease == EaseType.INHERIT else _convert_ease(animation.property_ease))
    tweener.set_trans(_convert_trans(trans) if animation.property_trans == TransitionType.INHERIT else _convert_trans(animation.property_trans))
    if animation.property_as_relative:
        tweener.as_relative()

func _convert_ease(ease:EaseType) -> Tween.EaseType:
    match ease:
        EaseType.EASE_IN:
            return Tween.EaseType.EASE_IN
        EaseType.EASE_OUT:
            return Tween.EaseType.EASE_OUT
        EaseType.EASE_IN_OUT:
            return Tween.EaseType.EASE_IN_OUT
        EaseType.EASE_OUT_IN:
            return Tween.EaseType.EASE_OUT_IN
    return Tween.EaseType.EASE_IN_OUT

func _convert_trans(trans:TransitionType) -> Tween.TransitionType:
    match trans:
        TransitionType.TRANS_LINEAR:
            return Tween.TransitionType.TRANS_LINEAR
        TransitionType.TRANS_SINE:
            return Tween.TransitionType.TRANS_SINE
        TransitionType.TRANS_QUINT:
            return Tween.TransitionType.TRANS_QUINT
        TransitionType.TRANS_QUART:
            return Tween.TransitionType.TRANS_QUART
        TransitionType.TRANS_QUAD:
            return Tween.TransitionType.TRANS_QUAD
        TransitionType.TRANS_EXPO:
            return Tween.TransitionType.TRANS_EXPO
        TransitionType.TRANS_ELASTIC:
            return Tween.TransitionType.TRANS_ELASTIC
        TransitionType.TRANS_CUBIC:
            return Tween.TransitionType.TRANS_CUBIC
        TransitionType.TRANS_CIRC:
            return Tween.TransitionType.TRANS_CIRC
        TransitionType.TRANS_BOUNCE:
            return Tween.TransitionType.TRANS_BOUNCE
        TransitionType.TRANS_BACK:
            return Tween.TransitionType.TRANS_BACK
        TransitionType.TRANS_SPRING:
            return Tween.TransitionType.TRANS_SPRING
    return Tween.TransitionType.TRANS_LINEAR

func _convert_process_mode(pmode:TweenProcessMode) -> Tween.TweenProcessMode:
    match pmode:
        TweenProcessMode.TWEEN_PROCESS_PHYSICS:
            return Tween.TweenProcessMode.TWEEN_PROCESS_PHYSICS
        TweenProcessMode.TWEEN_PROCESS_IDLE:
            return Tween.TweenProcessMode.TWEEN_PROCESS_IDLE
    return Tween.TweenProcessMode.TWEEN_PROCESS_IDLE

func _convert_pause_mode(pmode:TweenPauseMode) -> Tween.TweenPauseMode:
    match pmode:
        TweenPauseMode.TWEEN_PAUSE_BOUND:
            return Tween.TweenPauseMode.TWEEN_PAUSE_BOUND
        TweenPauseMode.TWEEN_PAUSE_STOP:
            return Tween.TweenPauseMode.TWEEN_PAUSE_STOP
        TweenPauseMode.TWEEN_PAUSE_PROCESS:
            return Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS
    return Tween.TweenPauseMode.TWEEN_PAUSE_BOUND

func _on_internal_tween_finished() -> void:
    finished.emit()

func _on_internal_tween_loop_finished(loop_count:int) -> void:
    loop_finished.emit(loop_count)

func _is_valid_expression(exp:String) -> bool:
    var value: Variant
    if exp.is_empty():
        return true
    elif exp.begins_with("@") or exp.begins_with("$"):
        return true
    else:
        var expression:Expression = Expression.new()
        if expression.parse(exp) != OK:
            return false

        value = expression.execute()
        return not expression.has_execute_failed()
