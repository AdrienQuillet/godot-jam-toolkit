extends Node2D

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

static var _first_time:bool = true
static var _index:int = 0

#------------------------------------------
# Godot override functions
#------------------------------------------

func _ready() -> void:
    if _first_time:
        _first_time = false
        await get_tree().create_timer(10.0).timeout
    else:
        await get_tree().create_timer(2.0).timeout
    HSceneChanger.call(HSceneChanger.NATIVE_TEXTURES.keys()[_index], "res://demo/scene/change/second.tscn", 1.0)
    _index += 2
    if _index >= HSceneChanger.NATIVE_TEXTURES.size():
        _index = 0

#------------------------------------------
# Public functions
#------------------------------------------

#------------------------------------------
# Private functions
#------------------------------------------
