class_name School extends Node

export var fish_scene:PackedScene

export var count = 5

export var radius = 100

export var neighbor_distance = 20
export var max_neighbors = 10

var boids = []

export var cell_size = 10
export var partition = true
var cells = {}

func draw_gizmos():
	if partition:
		DebugDraw.draw_grid(Vector3.ZERO, Vector3.RIGHT * cell_size, Vector3.UP * cell_size, Vector2(50, 50), Color.aquamarine)

func position_to_cell(pos, cell_size, grid_size = 10000):        
	var p = Vector3( 
		floor(pos.x / cell_size)
		,floor(pos.y / cell_size) * grid_size
		,floor(pos.z / cell_size) * grid_size * grid_size
	)
	return p
	


func partition():
	cells.clear()	
	for boid in boids:
		var key = position_to_cell(boid.transform.origin, cell_size)
		if ! cells.has(key):
			cells[key] = []	
		cells[key].push_back(boid)

func _process(delta):
	if partition:
		partition()
	draw_gizmos()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for i in count:
		var fish = fish_scene.instance()		
		add_child(fish)
		var pos = Utils.random_point_in_unit_sphere() * radius
		fish.global_transform.origin = pos
		fish.global_transform.basis = Basis(Vector3.UP, rand_range(0, PI * 2.0))
		
		var boid
		if fish is Boid:
			boid = fish
		else:
			boid = fish.find_node("Boid", true)
		if boids.size() == 0:
			boid.draw_gizmos = true
		boids.push_back(boid)		
		
		var constrain = boid.get_node("Constrain")
		if constrain:
			constrain.center = $"../Center"	
			constrain.radius = radius
