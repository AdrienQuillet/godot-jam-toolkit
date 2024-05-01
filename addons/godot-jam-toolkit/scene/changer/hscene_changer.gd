extends Node
class_name HSceneChanger

##
## Utility to change from one scene to another with transitions
##

#------------------------------------------
# Constants
#------------------------------------------

const FADER_SCENE_PATH:String = "res://addons/godot-jam-toolkit/scene/changer/fader.tscn"

const NATIVE_TEXTURES:Dictionary = {
    "burst": preload("res://addons/godot-jam-toolkit/scene/changer/textures/burst.png"),
    "circular_swirl": preload("res://addons/godot-jam-toolkit/scene/changer/textures/circular_swirl.png"),
    "clock": preload("res://addons/godot-jam-toolkit/scene/changer/textures/clock.jpg"),
    "cloud": preload("res://addons/godot-jam-toolkit/scene/changer/textures/cloud.png"),
    "curtain": preload("res://addons/godot-jam-toolkit/scene/changer/textures/curtain.png"),
    "fractal": preload("res://addons/godot-jam-toolkit/scene/changer/textures/fractal.png"),
    "glass": preload("res://addons/godot-jam-toolkit/scene/changer/textures/glass.jpg"),
    "heart": preload("res://addons/godot-jam-toolkit/scene/changer/textures/heart.png"),
    "hor_blinds": preload("res://addons/godot-jam-toolkit/scene/changer/textures/hor_blinds.png"),
    "hor_brush": preload("res://addons/godot-jam-toolkit/scene/changer/textures/hor_brush.jpg"),
    "mandelbrot": preload("res://addons/godot-jam-toolkit/scene/changer/textures/mandelbrot.jpg"),
    "pixel": preload("res://addons/godot-jam-toolkit/scene/changer/textures/pixel.jpg"),
    "poly": preload("res://addons/godot-jam-toolkit/scene/changer/textures/poly.png"),
    "puzzle": preload("res://addons/godot-jam-toolkit/scene/changer/textures/puzzle.jpg"),
    "rain": preload("res://addons/godot-jam-toolkit/scene/changer/textures/rain.jpg"),
    "rectangle": preload("res://addons/godot-jam-toolkit/scene/changer/textures/rectangle.png"),
    "shine": preload("res://addons/godot-jam-toolkit/scene/changer/textures/shine.jpg"),
    "square_swirl": preload("res://addons/godot-jam-toolkit/scene/changer/textures/square_swirl.png"),
    "stripes": preload("res://addons/godot-jam-toolkit/scene/changer/textures/stripes.png"),
    "swish": preload("res://addons/godot-jam-toolkit/scene/changer/textures/swish.jpg"),
    "vert_brush": preload("res://addons/godot-jam-toolkit/scene/changer/textures/vert_brush.jpg"),
    "wash": preload("res://addons/godot-jam-toolkit/scene/changer/textures/wash.jpg"),
    "wipe": preload("res://addons/godot-jam-toolkit/scene/changer/textures/wipe.jpg")
}

enum ChangeMode {
    FADE_IN = 0,
    FADE_OUT = 1,
    FADE_OUT_IN = 2,
    BLEND = 3
}

#------------------------------------------
# Signals
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

@export var root_container:Node

#------------------------------------------
# Public variables
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

var _fader_node:Fader
var _new_scene_instance:Node
var _scene_promise:HPromise

var _mode:ChangeMode
var _duration:float
var _color:Color

var _scene_loader:HSceneLoader

#------------------------------------------
# Godot override functions
#------------------------------------------

func _ready() -> void:
    _scene_loader = HSceneLoader.new()
    add_child(_scene_loader)
    if root_container == null:
        root_container = get_tree().root
    _fader_node = preload(FADER_SCENE_PATH).instantiate()
    add_child(_fader_node)

    _fader_node.on_stop.connect(_on_fader_stopped)

#------------------------------------------
# Public functions
#------------------------------------------

func fade_in(scene_path:String, duration:float = 0.2, color:Color = Color.BLACK) -> void:
    _change_scene_to(scene_path, ChangeMode.FADE_IN, duration, color)

func fade_out(scene_path:String, duration:float = 0.2, color:Color = Color.BLACK) -> void:
    _change_scene_to(scene_path, ChangeMode.FADE_OUT, duration, color)

func fade_out_in(scene_path:String, duration:float = 0.2, color:Color = Color.BLACK) -> void:
    _change_scene_to(scene_path, ChangeMode.FADE_OUT_IN, duration, color)

func blend(scene_path:String, texture:Texture, duration:float = 0.2) -> void:
    _change_scene_to(scene_path, ChangeMode.BLEND, duration, Color.BLACK, texture)

func burst(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "burst", duration)

func circular_swirl(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "circular_swirl", duration)

func clock(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "clock", duration)

func cloud(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "cloud", duration)

func curtain(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "curtain", duration)

func fractal(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "fractal", duration)

func glass(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "glass", duration)

func heart(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "heart", duration)

func hor_blinds(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "hor_blinds", duration)

func hor_brush(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "hor_brush", duration)

func mandelbrot(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "mandelbrot", duration)

func pixel(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "pixel", duration)

func poly(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "poly", duration)

func puzzle(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "puzzle", duration)

func rain(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "rain", duration)

func rectangle(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "rectangle", duration)

func shine(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "shine", duration)

func square_swirl(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "square_swirl", duration)

func stripes(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "stripes", duration)

func swish(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "swish", duration)

func vert_brush(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "vert_brush", duration)

func wash(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "wash", duration)

func wipe(scene_path:String, duration:float = 0.2) -> void:
    _blend_native_texture(scene_path, "wipe", duration)

#------------------------------------------
# Private functions
#------------------------------------------

func _blend_native_texture(scene_path:String, texture_name:String, duration:float) -> void:
    blend(scene_path, NATIVE_TEXTURES[texture_name], duration)

func _change_scene_to(scene_path:String, mode:ChangeMode = ChangeMode.FADE_OUT_IN, duration:float = 0.2, color:Color = Color.BLACK, texture:Texture = null) -> void:
    _clean_state()

    # Always load the future scene !
    _scene_promise = _scene_loader.async_scene_instantiate(scene_path)
    _scene_promise.resolved.connect(_on_new_scene_instantiated)

    # Depending on mode, things can change
    _mode = mode
    _duration = duration
    _color = color
    match _mode:
        ChangeMode.FADE_IN:
            pass # Nothing to do now !
        ChangeMode.FADE_OUT:
            _fader_node.fade_out(_duration, _color)
        ChangeMode.FADE_OUT_IN:
            _duration /= 2
            _fader_node.fade_out(_duration, _color)
        ChangeMode.BLEND:
             _fader_node.blend(texture, duration, color)

    _fader_node.visible = true

func _clean_state() -> void:
    if _scene_promise and _scene_promise.resolved.is_connected(_on_new_scene_instantiated):
        _scene_promise.resolved.disconnect(_on_new_scene_instantiated)
    _scene_promise = null

func _on_new_scene_instantiated(scene_instance:Node) -> void:
    _new_scene_instance = scene_instance
    var current_scene_index:int = root_container.get_children().find(_get_current_scene_node())
    root_container.add_child(_new_scene_instance)
    root_container.move_child(_new_scene_instance, current_scene_index)

    if _fader_node.is_stopped() or _mode == ChangeMode.BLEND:
        _do_change_scene()

func _on_fader_stopped() -> void:
    if _new_scene_instance != null:
        _do_change_scene()

func _do_change_scene() -> void:
    root_container.remove_child(_get_current_scene_node())
    if root_container == get_tree().root:
        get_tree().current_scene = _new_scene_instance
    _new_scene_instance = null

    match _mode:
        ChangeMode.FADE_IN:
            _fader_node.fade_in(_duration, _color)
        ChangeMode.FADE_OUT:
            _fader_node.visible = false
        ChangeMode.FADE_OUT_IN:
            _fader_node.fade_in(_duration, _color)
        ChangeMode.BLEND:
            pass # Nothing to do

func _get_current_scene_node() -> Node:
    for i in range(root_container.get_child_count() - 1, -1, -1):
        var node:Node = root_container.get_child(i)
        if (not node is HSceneLoader):
            return node

    push_error("Unable to determine current scene")
    return null
