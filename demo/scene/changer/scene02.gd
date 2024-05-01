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

static var _index:int = 1
var _scene_changer:HSceneChanger

#------------------------------------------
# Godot override functions
#------------------------------------------

func _ready() -> void:
    _scene_changer = get_tree().get_first_node_in_group("scene_changer")
    await get_tree().create_timer(2.0).timeout
    _scene_changer.call(HSceneChanger.NATIVE_TEXTURES.keys()[_index], "res://demo/scene/changer/scene01.tscn", 1.0)
    _index += 2
    if _index >= HSceneChanger.NATIVE_TEXTURES.size():
        _index = 1

#------------------------------------------
# Public functions
#------------------------------------------

#------------------------------------------
# Private functions
#------------------------------------------

