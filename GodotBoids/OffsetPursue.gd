extends Node

export var leaderNodePath:NodePath
var leaderBoid:Node
var leaderOffset:Vector3

export var weight = 1.0
export var drawGizmos = true

var boid
var target:Vector3
var worldTarget:Vector3
var projected:Vector3
	
func _ready():
	boid = get_parent()
	leaderBoid = get_node(leaderNodePath)
	leaderOffset = boid.global_transform.origin - leaderBoid.global_transform.origin
	leaderOffset = leaderBoid.global_transform.basis.xform_inv(leaderOffset)
	
func _process(delta):
	if drawGizmos:
		DebugDraw.draw_line(projected, worldTarget, Color.aliceblue)			

func calculate():		
	worldTarget = leaderBoid.global_transform.xform(leaderOffset)
	var dist = boid.global_transform.origin.distance_to(worldTarget)
	var time = dist / boid.max_speed
	DebugDraw.set_text("Time", time)
	DebugDraw.set_text("leaderBoid.velocity", leaderBoid.velocity)
	projected = worldTarget + leaderBoid.velocity * time
	
	# DebugDraw.draw_sphere(projected, 1, Color.red)
	
	# return arrive(projected)

	return boid.arrive_force(projected, 50)
