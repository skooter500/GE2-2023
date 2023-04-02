class_name Alignment extends SteeringBehavior

var force = Vector3.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	boid.count_neighbors = true

func draw_gizmos():
	var t = Transform().looking_at(force, boid.transform.basis.y)
	t.origin = boid.transform.origin
	DebugDraw.draw_arrow(t, Color.yellow)
	
func calculate():
	force = Vector3.ZERO
	for i in boid.neighbors.size():
		var other = boid.neighbors[i]
		force += other.global_transform.basis.z
	if boid.neighbors.size() > 0:
		force = force / boid.neighbors.size()
		force -= boid.global_transform.basis.z
	return force
	
