class_name School extends Node

export var fish_scene:PackedScene

export var count = 5

export var radius = 100

export var neighbor_distance = 10

var boids = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in count:
		var fish = fish_scene.instance()		
		add_child(fish)
		var pos = Utils.random_point_in_unit_sphere() * radius
		pos = pos.normalized() * 20
		fish.global_transform.origin = pos
		fish.global_transform.basis = Basis(Vector3.UP, rand_range(0, PI * 2.0))
		
		var boid
		if fish is Boid:
			boid = fish
		else:
			boid = fish.find_node("Boid", true)
		boids.push_back(boid)		
		
		var constrain = boid.get_node("Constrain")
		if constrain:
			constrain.center = $"../Center"	
