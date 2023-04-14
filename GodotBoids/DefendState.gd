class_name DefendState extends State

var boid

onready var enemy = get_node("../../Attacker")

onready var bullet_scene:PackedScene


func get_class():
	return "DefendState"

# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	bullet_scene = load("Bullet1.tscn")
	pass # Replace with function body.

var timer
var can_fire = true

func _enter():
	boid.set_enabled_all(false)
	# boid.get_node("Wander").set_enabled(true)
	boid.get_node("Pursue").set_enabled(true)
	boid.get_node("Pursue").enemy_boid = enemy
	timer = Timer.new()
	add_child(timer)	
	timer.wait_time = 1
	timer.one_shot = false
	timer.start()
	timer.connect("timeout", self, "timeout")	

func _exit():
	boid.get_node("Pursue").set_enabled(false)
	

func timeout():
	can_fire = true

func _think():
	var to_enemy = enemy.global_transform.origin - boid.global_transform.origin
	var angle = boid.global_transform.basis.z.angle_to(to_enemy)
	if can_fire and angle < deg2rad(45) and to_enemy.length() < 200:
		var bullet = bullet_scene.instance()
		get_tree().get_current_scene().add_child(bullet)
		bullet.global_transform.origin = boid.global_transform.xform(Vector3.BACK * 1.25)
		bullet.global_transform.basis = boid.global_transform.basis
		can_fire = false		
	if to_enemy.length() > 200:
		boid.get_node("StateMachine").change_state(ReturnToBase.new())
		pass	
