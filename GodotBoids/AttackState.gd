class_name AttackState extends State

var boid

onready var pig = get_node("../../pig")
onready var base = get_node("../../Base")

onready var bullet_scene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	bullet_scene = load("Bullet1.tscn")
	pass # Replace with function body.

var timer
var can_fire = true

func _enter():
	boid.set_enabled_all(false)
	boid.get_node("Wander").enabled = true
	boid.get_node("Seek").target = base
	boid.get_node("Seek").enabled = true
	
	timer = Timer.new()
	add_child(timer)	
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.start()
	timer.connect("timeout", self, "timeout")	

func timeout():
	can_fire = true

func _think():
	var to_pig = pig.global_transform.origin - boid.global_transform.origin
	var angle = boid.global_transform.basis.z.angle_to(to_pig)
	if can_fire and angle < deg2rad(45) and to_pig.length() < 100:
		var bullet = bullet_scene.instance()
		get_tree().get_current_scene().add_child(bullet)
		bullet.global_transform.origin = boid.global_transform.xform(Vector3.BACK * 1.7)
		bullet.global_transform.basis = boid.global_transform.basis
		can_fire = false		
