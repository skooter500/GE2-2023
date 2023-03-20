extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.

func set_enabled(var behavior, var enabled):
	behavior.enabled = enabled
	behavior.set_process(enabled)



func _ready():
	$"../Harmonic".set_process(false)
	$"../NoiseWander".set_process(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
