extends Spatial

export var mass = 1
export var force = Vector3.ZERO
export var acceleration = Vector3.ZERO
export var velocity = Vector3.ZERO
export var speed:float
export(float) var maxSpeed = 10.0

export var seekEnabled = false
export var seekTarget: Vector3

export var targetNodePath:NodePath

var targetNode:Node

export var arriveEnabled = false
export var arriveTarget: Vector3
export var slowingDistance = 30

export var banking = 0.1

export var pathFollowEnabled = false
var pathIndex = 0
var path:Curve3D
var waypointSeekDistance = 2

export var pursueEnabled = false
export var enemyNodePath:NodePath
var enemyBoid:Node
var pursueTarget:Vector3

func _drawGizmos():
	
	DebugDraw.draw_line(transform.origin,  transform.origin + transform.basis.z * 10.0 , Color(0, 0, 1))
	DebugDraw.draw_line(transform.origin,  transform.origin + transform.basis.x * 10.0 , Color(1, 0, 0))
	DebugDraw.draw_line(transform.origin,  transform.origin + transform.basis.y * 10.0 , Color(0, 1, 0))
	DebugDraw.draw_line(transform.origin, transform.origin + (force), Color(1, 1, 0))
	
	if pursueEnabled:
		DebugDraw.draw_sphere(pursueTarget, 1, Color.red)
	
	if (arriveEnabled):
		DebugDraw.draw_sphere(targetNode.translation, slowingDistance, Color.blueviolet)


func pursue():
	var toEnemy = enemyBoid.transform.origin - transform.origin	
	var dist = toEnemy.length()	
	var time = dist / maxSpeed	
	pursueTarget = enemyBoid.transform.origin + enemyBoid.velocity * time	
	return seek(pursueTarget)

# Called when the node enters the scene tree for the first time.
func _ready():	
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	
	targetNode = get_node(targetNodePath)
	if pathFollowEnabled:
		path = $"../Path".get_curve()
		
	if pursueEnabled:
		enemyBoid = get_node(enemyNodePath)
	pass	
func seek(target: Vector3):	
	var toTarget = target - transform.origin
	toTarget = toTarget.normalized()
	var desired = toTarget * maxSpeed
	return desired - velocity
	
	
func arrive(target:Vector3):
	var toTarget = target - transform.origin
	var dist = toTarget.length()
	var ramped = (dist / slowingDistance) * maxSpeed
	var clamped = min(maxSpeed, ramped)
	var desired = (toTarget * clamped) / dist 
	return desired - velocity

func followPath():
	var target = path.get_point_position(pathIndex)
	var dist = transform.origin.distance_to(target)
	if dist < waypointSeekDistance:
		pathIndex = (pathIndex + 1) % path.get_point_count()
	return seek(path.get_point_position(pathIndex))	


func calculate():
	var f = Vector3.ZERO
	if seekEnabled:
		seekTarget = targetNode.transform.origin	
		f += seek(seekTarget)
	if arriveEnabled:
		arriveTarget = targetNode.transform.origin
		f += arrive(arriveTarget)
	if (pathFollowEnabled):
		f += followPath()
	if pursueEnabled:
		f += pursue()
	return f
	
func _process(delta):			
	
	force = calculate()
	acceleration = force / mass
	velocity += acceleration * delta
	speed = velocity.length()
	if speed > 0:
		# To move a Spatial use any of these:
		# transform.origin += velocity * delta
		# translation += velocity * delta 		
		global_translate(velocity * delta)		
		
		# print(theta)
		# rotation = Vector3(0, theta, 0)
		# rotate_y(theta)
		# transform.origin += velocity * delta
		
		# Implement Banking as described:
		# https://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/
		var tempUp = transform.basis.y.linear_interpolate(Vector3.UP + (acceleration * banking), delta)
		look_at(transform.origin - velocity, tempUp)
	_drawGizmos()	
		
