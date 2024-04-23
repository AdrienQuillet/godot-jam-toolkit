extends CanvasLayer
class_name Fader

#------------------------------------------
# Constants
#------------------------------------------

#------------------------------------------
# Signals
#------------------------------------------

signal on_start
signal on_stop

#------------------------------------------
# Exports
#------------------------------------------

#------------------------------------------
# Public variables
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

@onready var _fade: TextureRect = $Fade

# Use when there is no blend with the next scene, so there is no texture on _fade texture rect
var _one_pixel_texture:Texture2D
# Tween node currently running
var _tween:HTween
# Whether the fader is running or not
var _stopped:bool = true

#------------------------------------------
# Godot override functions
#------------------------------------------

func _init() -> void:
    # When there is no texture to use
    var image:Image = Image.create(1, 1, false, Image.FORMAT_RGBA8)
    image.fill(Color.WHITE)
    _one_pixel_texture = ImageTexture.create_from_image(image)

#------------------------------------------
# Public functions
#------------------------------------------

func is_stopped() -> bool:
    return _stopped

func fade_out(duration:float = 0.2, color:Color = Color.BLACK) -> void:
    _clean_state()
    _fade.texture = _one_pixel_texture
    _fade.material.set("shader_parameter/color", color)
    _fade.material.set("shader_parameter/reverse", false)
    _fade.material.set("shader_parameter/use_texture", false)
    _fade.material.set("shader_parameter/texture", null)
    _tween = HTweenBuilder.build_tween(_fade).new_step().tween_method(_update_fade_material_opacity, 0.0, 1.0, duration).build()
    _after_configuration()

func fade_in(duration:float = 0.2, color:Color = Color.BLACK) -> void:
    _clean_state()
    _fade.texture = _one_pixel_texture
    _fade.material.set("shader_parameter/color", color)
    _fade.material.set("shader_parameter/reverse", true)
    _fade.material.set("shader_parameter/use_texture", false)
    _fade.material.set("shader_parameter/texture", null)
    _tween = HTweenBuilder.build_tween(_fade).new_step().tween_method(_update_fade_material_opacity, 1.0, 0.0, duration).build()
    _after_configuration()

func blend(texture:Texture, duration:float = 0.2, color:Color = Color.BLACK) -> void:
    _clean_state()
    _fade.texture = ImageTexture.create_from_image(get_tree().root.get_texture().get_image())
    _fade.material.set("shader_parameter/color", color)
    _fade.material.set("shader_parameter/use_texture", true)
    _fade.material.set("shader_parameter/reverse", false)
    _fade.material.set("shader_parameter/texture", texture)
    _tween = HTweenBuilder.build_tween(_fade).new_step().tween_method(_update_fade_material_opacity, 1.0, 0.0, duration).build()
    _after_configuration()

#------------------------------------------
# Private functions
#------------------------------------------

func _clean_state() -> void:
    if _tween:
        _tween.stop()
        _tween.kill()
        _tween.queue_free()
    _stopped = false

func _after_configuration() -> void:
    _tween.finished.connect(func():
        _stopped = true
        on_stop.emit())
    # Deferred call since the fade will really starts at next frame
    emit_signal.call_deferred("on_start")

func _update_fade_material_opacity(opacity:float) -> void:
    _fade.material.set("shader_parameter/opacity", opacity)
