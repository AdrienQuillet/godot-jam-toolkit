extends RefCounted
class_name HTweenBuilder

##
## [HTween] builder, usefull when creating [HTween] from code.
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

var _tween:HTween
var _bind_node:Node

#------------------------------------------
# Godot override functions
#------------------------------------------

func _init(bind_node:Node) -> void:
    _tween = HTween.new()
    _tween.configuration_mode = HTween.ConfigurationMode.ADVANCED
    _bind_node = bind_node

#------------------------------------------
# Public functions
#------------------------------------------

static func build_tween(bind_node:Node) -> HTweenBuilder:
    return HTweenBuilder.new(bind_node)

func loop_indefinitely(loop:int) -> HTweenBuilder:
    _tween.loop_mode = HTween.LoopMode.LOOP
    _tween.loop_count = 0
    return self

func loop_count(loop:int) -> HTweenBuilder:
    _tween.loop_mode = HTween.LoopMode.LOOP
    _tween.loop_count = max(0, loop)
    return self

func autostart() -> HTweenBuilder:
    _tween.autostart = true
    return self

func manual_start() -> HTweenBuilder:
    _tween.autostart = false
    return self

func default_ease(ease:HTween.EaseType) -> HTweenBuilder:
    _tween.ease = ease
    return self

func default_trans(trans:HTween.TransitionType) -> HTweenBuilder:
    _tween.trans = trans
    return self

func process_mode(mode:HTween.TweenProcessMode) -> HTweenBuilder:
    _tween.tween_process_mode = mode
    return self

func pause_mode(mode:HTween.TweenPauseMode) -> HTweenBuilder:
    _tween.tween_pause_mode = mode
    return self

func new_step(parallel:bool = false, human_desc:String = "") -> HTweenStepBuilder:
    return HTweenStepBuilder.build_step(self, parallel, human_desc)

func build() -> HTween:
    _bind_node.add_child(_tween)
    return _tween

#------------------------------------------
# Private functions
#------------------------------------------

