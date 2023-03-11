extends Spatial



# Declare member variables here. Examples:

export var width = 10
export var height = 10

export (PackedScene) var brickScene


# Called when the node enters the scene tree for the first time.
func _ready():	
	randomize()
	var half = width / 2
	for j in height:
		for i in width:				
			var brick = brickScene.instance()
			var s = 2			
			var pos = Vector3((i - half) * s , 1 + (j * s), 0)
			brick.transform.origin = pos
			# var mi  = brick.get_node("MeshInstance")
			# var newMaterial = SpatialMaterial.new()
			# newMaterial.albedo_color = Color.from_hsv(randf(), 1, 1)
			# mi.set_surface_material(0, newMaterial)
			add_child(brick)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	pass # Replace with function body.
