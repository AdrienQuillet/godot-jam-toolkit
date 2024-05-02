extends HFXBase
class_name HFXMove2D

##
## Allow to move any [Node] with a [code]position[/code] property described as a [code]Vector2[/code].
##
## [br]
##
## This effect do not use tween internally, to be compatible with other effects (cumulative effect).
##
## [br]
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
## Movement to apply to the target node.
@export var movement:Vector2 = Vector2.ZERO

@export_category("Animation Duration")
## Duration, in seconds, of the shake effect
@export var duration:float = 0.5

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
# Initial target node position
var _initial_target_position:Vector2
# Target effect position
var _target_position:Vector2

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
    _initial_target_position = target_node.position
    _target_position = _initial_target_position + movement

func _process_effect(delta:float) -> void:
    _ellapsed_time += delta

    # Is FX effect done ?
    if _ellapsed_time > _duration:
        stop()
        return

    # Lerp movement base on ellapsed time
    target_node.position = _initial_target_position.lerp(_target_position, _ellapsed_time / duration)
