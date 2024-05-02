extends HFXBase
class_name HFXModulate

##
## Allow to change modulation of any [Node that pocess a [code]modulate[/code] property.
##
## [br]
##
## As all FX effects, this can be cumulated with other FX effects.
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
## Target modulation
@export var target_modulate:Color = Color.WHITE

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
# Initial target node modulate
var _initial_target_modulate:Color

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
    _initial_target_modulate = target_node.modulate

func _process_effect(delta:float) -> void:
    _ellapsed_time += delta

    # Is FX effect done ?
    if _ellapsed_time > _duration:
        stop()
        return

    # Lerp movement base on ellapsed time
    target_node.modulate = lerp(_initial_target_modulate, target_modulate, _ellapsed_time / duration)
