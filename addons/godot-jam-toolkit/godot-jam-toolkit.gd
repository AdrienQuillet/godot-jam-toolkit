@tool
extends EditorPlugin

const SINGLETONS:Dictionary = {
    "HSceneLoader" : "res://addons/godot-jam-toolkit/scene_loader/hscene_loader.gd"
}

func _enter_tree() -> void:
    for singleton_name in SINGLETONS:
        add_autoload_singleton(singleton_name, SINGLETONS[singleton_name])


func _exit_tree() -> void:
    for singleton_name in SINGLETONS:
        remove_autoload_singleton(singleton_name)
