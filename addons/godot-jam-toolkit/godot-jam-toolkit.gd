@tool
extends EditorPlugin

const CUSTOM_TYPES:Dictionary = {
    "HReferencer": {
        "base_type": "Node",
        "script": preload("res://addons/godot-jam-toolkit/reference/hreferencer.gd"),
        "icon_texture": null
    },
    "HAudioManager": {
        "base_type": "Node",
        "script": preload("res://addons/godot-jam-toolkit/audio/haudio_manager.gd"),
        "icon_texture": null
    },
    "HSceneLoader": {
        "base_type": "Node",
        "script": preload("res://addons/godot-jam-toolkit/scene/loader/hscene_loader.gd"),
        "icon_texture": null
    },
    "HSceneChanger": {
        "base_type": "Node",
        "script": preload("res://addons/godot-jam-toolkit/scene/changer/hscene_changer.gd"),
        "icon_texture": null
    },
    "HGuiAnimator": {
        "base_type": "Node",
        "script": preload("res://addons/godot-jam-toolkit/gui/animation/hgui_animator.gd"),
        "icon_texture": null
    },
    "HFXShake2D": {
        "base_type": "Node",
        "script": preload("res://addons/godot-jam-toolkit/fx/hfx_shake_2d.gd"),
        "icon_texture": null
    },
    "HFXMove2D": {
        "base_type": "Node",
        "script": preload("res://addons/godot-jam-toolkit/fx/hfx_move_2d.gd"),
        "icon_texture": null
    },
    "HFXModulate": {
        "base_type": "Node",
        "script": preload("res://addons/godot-jam-toolkit/fx/hfx_modulate.gd"),
        "icon_texture": null
    },
    "HTween": {
        "base_type": "Node",
        "script": preload("res://addons/godot-jam-toolkit/tween/htween.gd"),
        "icon_texture": null
    }
}

func _enter_tree() -> void:
    for custom_type_name in CUSTOM_TYPES:
        var custom_type_data:Dictionary = CUSTOM_TYPES[custom_type_name]
        add_custom_type(custom_type_name, custom_type_data.base_type, custom_type_data.script, custom_type_data.icon_texture)

func _exit_tree() -> void:
    for custom_type_name in CUSTOM_TYPES:
        remove_custom_type(custom_type_name)
