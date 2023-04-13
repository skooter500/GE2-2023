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


func get_class():
	return "AttackState"

var timer
var can_fire = true

func _enter():
	boid.set_enabled_all(false)
	boid.get_node("Wander").enabled = true
	
	# seek target
	var to_base = base.global_transform.origin - boid.global_transform.origin
	to_base = to_base.normalized()
	var target = base.global_transform.origin + (to_base * 50)	
	boid.get_node("Seek").enabled = true
	
	timer = Timer.new()
	add_child(timer)	
	timer.wait_time = 0.5
	timer.one_shot = false
	timer.start()
	timer.connect("timeout", self, "timeout")	

func timeout():
	can_fire = true

func _think():
	var to_base = base.global_transform.origin - boid.global_transform.origin
	var angle = boid.global_transform.basis.z.angle_to(to_base)
	if can_fire and angle < deg2rad(45) and to_base.length() < 100:
		var bullet = bullet_scene.instance()
		get_tree().get_current_scene().add_child(bullet)
		bullet.global_transform.origin = boid.global_transform.xform(Vector3.BACK * 1.25)
		bullet.global_transform.basis = boid.global_transform.basis
		can_fire = false
	if to_base.length() < 10:
		boid.get_node("StateMachine").change_state(RetreatState.new())
		pass	
