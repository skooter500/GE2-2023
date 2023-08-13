class_name Avoidance extends SteeringBehavior
	
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum ForceDirection {Normal, Incident, Up, Braking}
export var direction = ForceDirection.Normal
export var feeler_angle = 45
export var feeler_length = 10
export var updates_per_second = 5

var force = Vector3.ZERO
var feelers = []
var space_state
var needs_updating = true

func draw_gizmos():
	for i in feelers.size():
		var feeler = feelers[i]		
		
		if feeler.hit:
			DebugDraw.draw_line(boid.global_transform.origin, feeler.hit_target, Color.chartreuse)
			DebugDraw.draw_arrow_line(feeler.hit_target, feeler.hit_target + feeler.normal, Color.blue, 0.1)
			DebugDraw.draw_arrow_line(feeler.hit_target, feeler.hit_target + feeler.force * weight, Color.red, 0.1)			
		else:
			DebugDraw.draw_line(boid.global_transform.origin, feeler.end, Color.chartreuse)

func start_updating():
	
	var timer = get_child(0)
	timer.disconnect("timeout", self, "start_updating")
	timer.wait_time = 1.0 / updates_per_second	
	timer.connect("timeout", self, "needs_updating")
	
	timer.one_shot = false
	timer.start()


func needs_updating():
	needs_updating = true

func _physics_process(var delta):
	if needs_updating:
		update_feelers()
		needs_updating = false		

func feel(local_ray):
	var feeler = {}
	var ray_end = boid.global_transform.xform(local_ray)
	var result = space_state.intersect_ray(boid.global_transform.origin, ray_end, [boid], boid.collision_mask)
	feeler.end = ray_end
	feeler.hit = result
	if result:
		feeler.hit_target = result.position
		feeler.normal = result.normal
		var to_boid = boid.global_transform.origin - result.position 
		var force_mag = ((feeler_length - to_boid.length()) / feeler_length)
		match direction:
			ForceDirection.Normal:
				feeler.force = result.normal * force_mag
			ForceDirection.Incident:
				feeler.force = to_boid.reflect(result.normal).normalized() * force_mag
			ForceDirection.Up:
				feeler.force = Vector3.UP * force_mag
			ForceDirection.Braking:
				feeler.force = to_boid.normalized() * force_mag
		force += feeler.force
	return feeler

func update_feelers():
	force = Vector3.ZERO
	feelers.clear()
	var forwards = Vector3.BACK * feeler_length
	feelers.push_back(feel(forwards))
	feelers.push_back(feel(Quat(Vector3.UP, deg2rad(feeler_angle)) * forwards))
	feelers.push_back(feel(Quat(Vector3.UP, deg2rad(-feeler_angle)) * forwards))

	feelers.push_back(feel(Quat(Vector3.RIGHT, deg2rad(feeler_angle)) * forwards))
	feelers.push_back(feel(Quat(Vector3.RIGHT, deg2rad(-feeler_angle)) * forwards))

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
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = rand_range(0.0, 1.0)
	timer.one_shot = true
	timer.connect("timeout", self, "start_updating")
	timer.start()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
