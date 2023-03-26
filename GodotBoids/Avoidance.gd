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
var ray_end
var hit_target

func draw_gizmos():
	DebugDraw.draw_line(boid.global_transform.origin, ray_end, Color.aqua)
	if force != Vector3.ZERO:
		# draw_line_hit_offset
		DebugDraw.draw_arrow_line(hit_target, hit_target + force, Color.red, 0.1)

func _physics_process(var delta):
	force = Vector3.ZERO
	var space_state = boid.get_world().direct_space_state
	ray_end = boid.global_transform.origin + boid.global_transform.basis.z * feeler_length
	var result = space_state.intersect_ray(boid.global_transform.origin, ray_end)
	if result:
		var to_boid = result.position - boid.global_transform.origin
		var force_mag = to_boid.length()
		match direction:
			ForceDirection.Normal:
				force = result.normal * force_mag
			ForceDirection.Incident:
				force = to_boid.reflect(result.normal) * force_mag
			ForceDirection.Up:
				force = Vector3.UP * force_mag
			ForceDirection.Braking:
				force = to_boid * force_mag

func calculate():
	return force



# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
