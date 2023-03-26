class_name Avoidance extends SteeringBehavior
	
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum ForceDirection {Normal, Incident, Up, Braking}
export var direction = ForceDirection.Normal
export var feeler_angle = 60
export var feeler_length = 10
export var updates_per_second = 10

var force = Vector3.ZERO
var feelers = []
var space_state

func draw_gizmos():
	for i in feelers.size():
		var feeler = feelers[i]		
		
		if feeler.hit:
			DebugDraw.draw_line(boid.global_transform.origin, feeler.hit_target, Color.aqua)
			DebugDraw.draw_arrow_line(feeler.hit_target, feeler.hit_target + feeler.force, Color.red, 0.1)
		else:
			DebugDraw.draw_line(boid.global_transform.origin, feeler.end, Color.aqua)

func _physics_process(var delta):
	update_feelers()		

func feel(local_ray):
	var feeler = {}
	var ray_end = boid.global_transform.xform(local_ray)
	var result = space_state.intersect_ray(boid.global_transform.origin, ray_end)
	feeler.end = ray_end
	feeler.hit = result
	if result:
		feeler.hit_target = result.position
		var to_boid = result.position - boid.global_transform.origin
		var force_mag = to_boid.length()
		match direction:
			ForceDirection.Normal:
				feeler.force = result.normal * force_mag
			ForceDirection.Incident:
				feeler.force = to_boid.reflect(result.normal) * force_mag
			ForceDirection.Up:
				feeler.force = Vector3.UP * force_mag
			ForceDirection.Braking:
				feeler.force = to_boid * force_mag
		force += feeler.force
	return feeler

func update_feelers():
	force = Vector3.ZERO
	feelers.clear()
	var forwards = Vector3.BACK * feeler_length
	feelers.push_back(feel(forwards))
	feelers.push_back(feel(Quat(Vector3.UP, 45) * forwards))
	feelers.push_back(feel(Quat(Vector3.UP, -45) * forwards))

	feelers.push_back(feel(Quat(Vector3.RIGHT, 45) * forwards))
	feelers.push_back(feel(Quat(Vector3.RIGHT, -45) * forwards))

	# Forwards feeler			
	
	
	
	
	# 
	
	# Tried with capsule cast, but cant get the collision points
#	var shape = PhysicsShapeQueryParameters.new()
#	shape.collide_with_areas = true
#	var s = CapsuleShape.new()
#	s.height = feeler_length
#	s.radius = 1
#	shape.set_shape(s)
#	shape.set_exclude([boid])
#	shape.transform = boid.global_transform
#
#	var results = space_state.intersect_shape(shape)    
	# var result = space_state.intersect_shape(shape)
#	for i in range(results.size()):
#		var result = results[i].collider
#		# raycast hit something, do something here
#		print("Capsule hit ", hit.collider.get_name())
#
	

func calculate():
	return force



# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	space_state = boid.get_world().direct_space_state
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
