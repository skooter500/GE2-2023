extends Node

export var targetNodePath:NodePath
var targetNode
var worldTarget:Vector3

export var weight = 1.0
var boid

func calculate():
	worldTarget = targetNode.global_transform.origin
	return boid.seek_force(worldTarget)


# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	targetNode = get_node(targetNodePath)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
