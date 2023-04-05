extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var boid = $"../School/Boid"
	$"../camera follower".transform.origin = boid.transform.origin + boid.transform.basis.z * 10.0
	$"../camera follower/OffsetPursue".leader_node_path = "../../School/Boid"
	$"../Camera/Control".boid_path = "../../School/Boid"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
