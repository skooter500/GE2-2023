class_name Flee extends SteeringBehavior

export var enemy_path:NodePath
var enemy_boid:Node

export var flee_range = 50

var force = Vector3.ZERO

func draw_gizmos():
	DebugDraw.draw_sphere(boid.global_transform.origin, flee_range, Color.darksalmon)
	
	if force != Vector3.ZERO:
		DebugDraw.draw_arrow_line(boid.global_transform.origin, enemy_boid.global_transform.origin, Color.darksalmon)

func calculate():
	var to_enemy = enemy_boid.global_transform.origin - boid.global_transform.origin
	DebugDraw.set_text("to_enemy", to_enemy.length())
	if to_enemy.length() < flee_range:
		to_enemy = to_enemy.normalized()
		var desired = to_enemy * boid.max_speed
		return boid.velocity - desired 
	else:
		return Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	if enemy_path:
		enemy_boid = get_node(enemy_path)


