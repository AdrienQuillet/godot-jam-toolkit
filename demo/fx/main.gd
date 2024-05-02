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

@onready var _move_effect: HFXMove2D = $Icon2/HFXMove2D
@onready var _shake_multi_effect: HFXShake2D = $Icon3/HFXShake2D
@onready var _move_multi_effect: HFXMove2D = $Icon3/HFXMove2D

#------------------------------------------
# Godot override functions
#------------------------------------------

#------------------------------------------
# Public functions
#------------------------------------------

#------------------------------------------
# Private functions
#------------------------------------------

func _on_hfx_move_2d_finished() -> void:
    _move_effect.movement = -_move_effect.movement
    _move_effect.play()

func _on_hfx_shake_multi_effect_finished() -> void:
    _shake_multi_effect.play()

func _on_hfx_move_multi_effect_finished() -> void:
    _move_multi_effect.movement = -_move_multi_effect.movement
    _move_multi_effect.play()
