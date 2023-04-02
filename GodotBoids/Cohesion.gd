class_name Cohesion extends SteeringBehavior


var force = Vector3.ZERO
var center_of_mass
# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	boid.count_neighbors = true

func draw_gizmos():
	for i in boid.neighbors.size():
		var other = boid.neighbors[i]
		var to_boid = boid.transform.origin - boid.neighbors[i].transform.origin
		to_boid = to_boid.normalized()
		DebugDraw.draw_arrow_line(other.global_transform.origin, other.global_transform.origin + to_boid * force.length() * weight * 2, Color.darkseagreen, 0.1)

func calculate():
	force = Vector3.ZERO
	center_of_mass = Vector3.ZERO
	for i in boid.neighbors.size():
		var other = boid.neighbors[i]
		center_of_mass += other.global_transform.origin
	if boid.neighbors.size() > 0:
		center_of_mass /= boid.neighbors.size()
		force = boid.seek_force(center_of_mass).normalized()
	return force
	
