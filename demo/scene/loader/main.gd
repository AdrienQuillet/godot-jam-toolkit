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

@onready var _scene_loader: HSceneLoader = $HSceneLoader

@onready var _progress_label: Label = $UI/CenterContainer/VBoxContainer/ProgressLabel
@onready var _load_button: Button = $UI/CenterContainer/VBoxContainer/HBoxContainer/LoadButton
@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite

var _loaded_sprite

#------------------------------------------
# Godot override functions
#------------------------------------------

func _ready() -> void:
    _animated_sprite.play()
    _scene_loader.on_scene_load_progress.connect(_on_scene_progress)

#------------------------------------------
# Public functions
#------------------------------------------

#------------------------------------------
# Private functions
#------------------------------------------

func _on_load_button_pressed() -> void:
    var node:Node = _scene_loader.immediate_scene_instantiate("res://demo/scene/loader/prop.tscn")
    _loaded_sprite = node
    add_child(node)
    node.position = _load_button.get_global_rect().position + _load_button.get_global_rect().size / 2 + Vector2(0, 150)

func _on_load_instantiate_button_pressed() -> void:
    _scene_loader.async_scene_instantiate("res://demo/scene/loader/prop.tscn").resolved.connect(_on_async_instantiate)

func _on_scene_progress(_scene_path:String, progress:float) -> void:
    _progress_label.text = "%s percent(s)" % (progress * 100)

func _on_async_instantiate(node:Node) -> void:
    _loaded_sprite = node
    add_child(node)
    node.position = _load_button.get_global_rect().position + _load_button.get_global_rect().size / 2 + Vector2(0, 150)

func _on_clear_button_pressed() -> void:
    if _loaded_sprite:
        remove_child(_loaded_sprite)
        _loaded_sprite = null
