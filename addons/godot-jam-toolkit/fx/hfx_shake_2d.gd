extends HFXBase
class_name HFXShake2D

##
## Allow to shake any [Node] with a [code]position[/code] property described as a [code]Vector2[/code].
##
## As all FX effects, this can be cumulated with other FX effects. Note that this effect is not
## compatible with tweens that animate node position, since tweens are executed after process methods,
## thus they override this effect animation.
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

@export_category("Animation")
## The node to animate. If [code]null[/code], the parent node will be the target
@export var target_node:Node
## Strength of the shake effect, in X and Y direction.
@export var shake_strength:Vector2 = Vector2(5.0, 5.0)
## If [code]true[/code], shake strength will be randomized between [code]Vector2.ZERO[/code] and
## [code]shake_strength[/code] at each frame.
@export var randomize_shake_strength:bool = false
## If [code]true[/code], the target node position is lerp instead of just changing its position.
## This reduces the number of time the position change, but the overall effect is better, especially
## if the [member shake_strength] is big.
@export var smooth_movement:bool = true

@export_category("Animation Duration")
## Duration, in seconds, of the shake effect
@export var duration:float = 0.5
## If greater than zero, [code]shake_strength[/code] will be lerp during the specified
## amount of time to reach its max value. Can not be greater than [code]duration / 2[/code]
@export var shake_strength_fade_in_duration:float = 0.0
## If greater than zero, [code]shake_strength[/code] will be lerp during the specified
## amount of time to reach [code]Vector2.ZERO[/code]. Can not be greater than [code]duration / 2[/code]
@export var shake_strength_fade_out_duration:float = 0.0

#------------------------------------------
# Public variables
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

# Duration of the animation
var _duration:float = 0.0
# Elapsed time since this effect has start running
var _ellapsed_time:float = 0.0
# Duration of strength fade in
var _fade_in_duration:float = 0.0
# Duration of strength fade out
var _fade_out_duration:float = 0.0
# Last effect applied: necessary to recompute original position of the node, in order to be able to cumulate
# effect, such as a move left/right and a shake without any bug
var _last_shake_strength:Vector2
# Potion to reached with _last_shake_strength
var _current_target_position:Vector2
# Is smoothing effect has to be applied ?
var _apply_smoothing_effect:bool
# Current iteration movement
var _current_movement:Vector2

#------------------------------------------
# Godot override functions
#------------------------------------------

#------------------------------------------
# Public functions
#------------------------------------------

#------------------------------------------
# Private functions
#------------------------------------------

func _do_play() -> void:
    if target_node == null:
        target_node = get_parent()
    _ellapsed_time = 0.0
    _duration = clamp(duration, 0, 9999999)
    _fade_in_duration = clamp(shake_strength_fade_in_duration, 0, duration / 2.0)
    _fade_out_duration = clamp(shake_strength_fade_out_duration, 0, duration / 2.0)
    _last_shake_strength = Vector2.ZERO
    _current_target_position = target_node.position
    _current_movement = Vector2.ZERO
    _apply_smoothing_effect = false

func _process_effect(delta:float) -> void:
    _ellapsed_time += delta

    # Is FX effect done ?
    if _ellapsed_time > _duration:
        stop()
        return

    # If previous target position is not reach,
    if _apply_smoothing_effect and smooth_movement:
        _apply_smoothing_effect = false
        target_node.position += _current_movement / 2
        return

    # Compute strength to apply during this frame
    _apply_smoothing_effect = true
    var applied_strength:Vector2 = shake_strength
    if _fade_in_duration > 0 and _ellapsed_time <= _fade_in_duration:
        applied_strength = Vector2.ZERO.lerp(shake_strength, _ellapsed_time / _fade_in_duration)
        if randomize_shake_strength:
            applied_strength = Vector2.ZERO.lerp(applied_strength, randf())
    elif _fade_out_duration > 0 and _ellapsed_time >= _duration - _fade_out_duration:
        applied_strength = Vector2.ZERO.lerp(shake_strength, (_duration - _ellapsed_time) / _fade_out_duration)
        if randomize_shake_strength:
            applied_strength = Vector2.ZERO.lerp(applied_strength, randf())
    elif randomize_shake_strength:
        applied_strength = Vector2.ZERO.lerp(shake_strength, randf())
    # else: use the parametreized strenght

    applied_strength = Vector2(applied_strength.x * _random_one_or_minus_one(), applied_strength.y * _random_one_or_minus_one())

    var original_position:Vector2 = target_node.position - _last_shake_strength
    _last_shake_strength = applied_strength
    _current_target_position = original_position + _last_shake_strength
    _current_movement = _current_target_position - target_node.position
    var movement:Vector2 = _current_movement
    if smooth_movement:
        movement /= 2

    target_node.position += movement

func _random_one_or_minus_one() -> int:
    return -1 if randi() % 2 == 0 else 1
