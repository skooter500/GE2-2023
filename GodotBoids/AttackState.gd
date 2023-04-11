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

func _enter():
	boid.set_enabled_all(false)
	boid.get_child("Wander").enabled = true
	boid.get_child("Seek").target = base
	boid.get_child("Seek").enabled = true
	
func _think():
	var to_pig = pig.global_transform.origin - boid.global_transform.origin
	var angle = boid.global_transform.basis.z.angle_to(to_pig)
	if angle < deg2rad(45):
		var bullet = bullet_scene.instance()
		get_tree().get_scene().add_child(bullet)
		bullet.global_transform.origin = boid.global_transform.xform(Vector3.BACK * 10)
		
