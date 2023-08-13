class_name OffsetPursue extends SteeringBehavior

export var leader_node_path:NodePath
var leader_boid:Node
var leader_offset:Vector3
var target:Vector3
var world_target:Vector3
var projected:Vector3

func draw_gizmos():
	DebugDraw.draw_sphere(world_target, 1, Color.green)
	DebugDraw.draw_sphere(projected, 1, Color.green)
	DebugDraw.draw_arrow_line(world_target, projected, Color.green, 0.1)	


func calculate_offset():
	leader_boid = get_node(leader_node_path)
	leader_offset = boid.global_transform.origin - leader_boid.global_transform.origin
	leader_offset = leader_boid.global_transform.basis.xform_inv(leader_offset)	

func _ready():
	boid = get_parent()
		
	if leader_node_path:
		leader_boid = get_node(leader_node_path)
		calculate_offset()
		
func _process(delta):
	if draw_gizmos:
		DebugDraw.draw_line(projected, world_target, Color.aliceblue)			

func calculate():		
	world_target = leader_boid.global_transform.xform(leader_offset)
	var dist = boid.global_transform.origin.distance_to(world_target)
	var time = dist / boid.max_speed
	projected = world_target + leader_boid.velocity * time
	

	return boid.arrive_force(projected, 30)
