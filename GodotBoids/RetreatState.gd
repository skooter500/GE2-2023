class_name RetreatState extends State

var boid
var target

var timer
var can_fire = true

onready var base = get_node("../../Base")

onready var bullet_scene:PackedScene

func timeout():
	can_fire = true
	timer.wait_time = rand_range(0.2, 1)


func _enter():
	target = get_tree().get_current_scene().find_node("AttackerBase").global_transform.origin
	boid.get_node("Seek").world_target = target
	boid.get_node("Seek").set_enabled(true)

func _exit():
	boid.get_node("Seek").set_enabled(false)
	pass

func _think():	
	var to_base = base.global_transform.origin - boid.global_transform.origin
	var angle = boid.global_transform.basis.z.angle_to(to_base)
	if can_fire and angle < deg2rad(45) and to_base.length() < 400:
		var bullet = bullet_scene.instance()
		get_tree().get_current_scene().add_child(bullet)
		bullet.global_transform.origin = boid.global_transform.xform(Vector3.BACK * 1.25)
		bullet.global_transform.basis = boid.global_transform.basis
		can_fire = false

	
	if target.distance_to(boid.global_transform.origin) < 5:
		
		# See: https://www.reddit.com/r/godot/comments/hu213d/class_was_found_in_global_scope_but_its_script/		
		# boid.get_node("StateMachine").change_state(AttackState.new())
		var AttackState = load("res://AttackState.gd")
		boid.get_node("StateMachine").change_state(AttackState.new())
		pass
		
func get_class():
	return "RetreatState"
	
func _ready():
	boid = get_parent()
	bullet_scene = load("Bullet1.tscn")

	timer = Timer.new()
	add_child(timer)	
	timer.wait_time = 1
	timer.one_shot = false
	timer.start()
	timer.connect("timeout", self, "timeout")	


	pass
