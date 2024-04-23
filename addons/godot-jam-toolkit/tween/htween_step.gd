extends Resource
class_name HTweenStep

#------------------------------------------
# Constants
#------------------------------------------

#------------------------------------------
# Signals
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

@export_placeholder("Human readable step name") var name:String
@export var parallel:bool = false:
    set(value):
        if parallel != value:
            parallel = value
            emit_changed()

@export var animations:Array[HTweenAnimation]:
    set(value):
        if value == animations:
            return
        for old_anim in animations:
            if old_anim != null:
                if old_anim.changed.is_connected(emit_changed):
                    old_anim.changed.disconnect(emit_changed)
        animations = value
        if animations != null:
            for i in animations.size():
                if animations[i] == null:
                    animations[i] = HTweenAnimation.new()
                animations[i].changed.connect(emit_changed)
        emit_changed()

#------------------------------------------
# Public variables
#------------------------------------------

#------------------------------------------
# Private variables
#------------------------------------------

#------------------------------------------
# Godot override functions
#------------------------------------------

#------------------------------------------
# Public functions
#------------------------------------------

#------------------------------------------
# Private functions
#------------------------------------------

