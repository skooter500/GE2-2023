class_name FireAtTargetGlobalState extends State

export var target_path:NodePath

var boid
onready var bullet_scene:PackedScene
var target
var timer
var can_fire = true

# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	target = get_node(target_path)
	bullet_scene = load("Bullet1.tscn")
	timer = Timer.new()
	add_child(timer)	
	timer.wait_time = 1
	timer.one_shot = false
	timer.start()
	timer.connect("timeout", self, "timeout")	

	
	pass # Replace with function body.

func timeout():
	can_fire = true
	timer.wait_time = rand_range(0.2, 1)

func get_class():
	return "FireAtATargetGlobalState"	

func _enter():
	pass
		
func _think():
	if can_fire:
		var to_target = target.global_transform.origin - boid.global_transform.origin
		var angle = rad2deg(boid.global_transform.basis.z.angle_to(to_target))

		var dist = to_target.length()

		if angle < 30 and dist < 400:
			var bullet = bullet_scene.instance()
			get_tree().get_current_scene().add_child(bullet)
			bullet.global_transform.origin = boid.global_transform.xform(Vector3.BACK * 1.3)
			bullet.global_transform.basis = boid.global_transform.basis
			can_fire = false
