class_name Seek extends SteeringBehavior

export var targetNodePath:NodePath
var targetNode
var worldTarget:Vector3

func calculate():
	worldTarget = targetNode.global_transform.origin
	return boid.seek_force(worldTarget)


# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	if targetNodePath:
		targetNode = get_node(targetNodePath)

