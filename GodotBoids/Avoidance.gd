extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum ForceDirection {Normal, Incident, Up, Braking}
export var direction = ForceDirection.Normal
export var feeler_angle = 60
export var feeler_length = 10
export var updates_per_second = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
