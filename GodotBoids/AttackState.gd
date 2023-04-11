class_name AttackState extends State

var boid

onready var pig = get_node("../../pig")
onready var base = get_node("../../Base")

onready var bullet_scene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	bullet_scene = load("Bullet.tscn")
	pass # Replace with function body.

var timer
var can_fire = true

func _enter():
	boid.set_enabled_all(false)
	boid.get_node("Wander").enabled = true
	boid.get_node("Seek").target = base
	boid.get_node("Seek").enabled = true
	
	var timer = Timer.new()
	timer.wait_time = 1.0 / 5.0
	add_child(timer)
	timer.connect("timeout", self, "timeout")	

	
func timeout():
	can_fire = true
	timer.queue_free()

		
func _think():
	var to_pig = pig.global_transform.origin - boid.global_transform.origin
	var angle = boid.global_transform.basis.z.angle_to(to_pig)
	if can_fire and angle < deg2rad(45) and to_pig.length() < 100:
		print("Shooting!")
		var bullet = bullet_scene.instance()
		get_tree().get_current_scene().add_child(bullet)
		bullet.global_transform.origin = boid.global_transform.xform(Vector3.BACK * 10)
		bullet.global_transform.basis = boid.global_transform.basis
		can_fire = false		
