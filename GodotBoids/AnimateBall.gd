extends AnimationPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var forwards = true
# Called when the node enters the scene tree for the first time.
func _ready():
	play("LeftAndRight")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if forwards:
		play_backwards("LeftAndRight")
	else:
		play("LeftAndRight")
	forwards = ! forwards
	pass # Replace with function body.
