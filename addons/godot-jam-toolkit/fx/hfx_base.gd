extends Node
class_name HFXBase
# Abstract

##
## Base class for all FX nodes. Should never be instantiated
##

#------------------------------------------
# Constants
#------------------------------------------

enum ProcessMode {
    ## Process effect on process frame
    PROCESS = 0,
    ## Process effect on physics process frame
    PHYSICS_PROCESS = 1
}

#------------------------------------------
# Signals
#------------------------------------------

## Emitted when the FX effect starts
signal started
## Emitted when the FX effect is manually stopped (see [method stop]) or finished.
signal finished

#------------------------------------------
# Exports
#------------------------------------------

@export_category("Effect")
## Tells if this animation immediatly starts when added to the SceneTree or not
@export var auto_start:bool = true
## If [code]true[/code], the FX effect is queue free when the FX is finished
@export var queue_free_on_finish:bool = true

@export_category("Process")
## When this effect is applied
@export var effect_process_mode:HFXBase.ProcessMode = HFXBase.ProcessMode.PROCESS

#------------------------------------------
# Public variables
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

# Is this effect running ?
var _playing:bool = false

#------------------------------------------
# Godot override functions
#------------------------------------------

func _ready() -> void:
    set_process(false)
    set_physics_process(false)

    if auto_start:
        play()

func _process(delta: float) -> void:
    _process_effect(delta)

func _physics_process(delta: float) -> void:
    _process_effect(delta)

#------------------------------------------
# Public functions
#------------------------------------------

## Start the effect immediately.
func play() -> void:
    assert(is_inside_tree(), "Can not apply effect when effect node is not in SceneTree")
    if _playing:
        return

    _playing = true
    _do_play()

    if effect_process_mode == HFXBase.ProcessMode.PROCESS:
        set_process(true)
    elif effect_process_mode == HFXBase.ProcessMode.PHYSICS_PROCESS:
        set_physics_process(true)

    # Delete on finish if necessary
    if queue_free_on_finish:
        if not finished.is_connected(queue_free):
            finished.connect(queue_free)

    started.emit()

## Stop the effect.
func stop() -> void:
    if not _playing:
        return

    _playing = false
    set_process(false)
    set_physics_process(false)

    finished.emit()

#------------------------------------------
# Private functions
#------------------------------------------

func _do_play() -> void:
    push_error("To override")
    pass

func _process_effect(_delta:float) -> void:
    push_error("To override")
    pass
