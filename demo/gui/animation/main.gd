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

@onready var _gui_animator: HGuiAnimator = $HGuiAnimator

#------------------------------------------
# Godot override functions
#------------------------------------------

#------------------------------------------
# Public functions
#------------------------------------------

#------------------------------------------
# Private functions
#------------------------------------------

func _on_hide_button_pressed() -> void:
    _gui_animator.hide()

func _on_show_button_pressed() -> void:
    _gui_animator.show()

func _on_h_gui_animator_hide_finished() -> void:
    print("Hide finished")

func _on_h_gui_animator_hide_started() -> void:
    print("Hide started")

func _on_h_gui_animator_show_finished() -> void:
    print("Show finished")

func _on_h_gui_animator_show_started() -> void:
    print("Show started")
