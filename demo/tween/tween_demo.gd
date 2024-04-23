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

@onready var icon_2: Sprite2D = $Icon2

#------------------------------------------
# Godot override functions
#------------------------------------------

func _ready() -> void:
    HTweenBuilder.build_tween(icon_2) \
        .autostart() \
        .default_trans(HTween.TransitionType.TRANS_EXPO) \
        .new_step(true, "Diagonal move") \
            .tween_property(icon_2, "position:x", 150, 2.0).as_relative() \
            .tween_property(icon_2, "position:y", 80, 2.0).as_relative() \
        .new_step(false, "Vertical move") \
            .tween_property(icon_2, "position", Vector2(0, 100), 1.0).as_relative() \
    .build()

#------------------------------------------
# Public functions
#------------------------------------------

#------------------------------------------
# Private functions
#------------------------------------------

