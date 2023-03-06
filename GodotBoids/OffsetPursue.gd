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
	leaderOffset = leaderBoid.transform.basis.xform_inv(boid.transform.origin)
	
func _process(delta):
	if drawGizmos:
		DebugDraw.draw_sphere(worldTarget, 1, Color.aliceblue)
		DebugDraw.draw_box(projected, Vector3.ONE, Color.aliceblue)			

func calculate():		
	worldTarget = leaderBoid.transform.basis.xform(leaderOffset)
	var dist = boid.transform.origin.distance_to(worldTarget)
	var time = dist / boid.max_speed
	
	projected = worldTarget + leaderBoid.velocity * time
	
	# DebugDraw.draw_sphere(projected, 1, Color.red)
	
	# return arrive(projected)

	return boid.seek_force(projected)
