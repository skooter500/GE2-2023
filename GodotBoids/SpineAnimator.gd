extends Spatial

export var bonePaths = []
export var damping:float = 0.1

var bones = [] 
var offsets = [] 

func calculateOffsets():
	bones.clear()
	offsets.clear()	
	for i in bonePaths.size():
		var bone = get_node(bonePaths[i])
		bones.push_back(bone)
		if i > 0:
			var offset = bones[i].global_transform.origin - bones[i-1].global_transform.origin
			offset = bones[i-1].global_transform.basis.xform_inv(offset)
			offsets.push_back(offset)
	print("Bones:" + str(bones))
	print("Offsets:" + str(offsets))

# Called when the node enters the scene tree for the first time.
func _ready():
	calculateOffsets()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for i in offsets.size():
		var prev = bones[i]
		var next = bones[i + 1]
		
		var wantedPos = prev.global_transform.xform(offsets[i])
	
		# Clamp it, so they dont get too far apart
		var lerped = lerp(next.global_transform.origin, wantedPos, delta * damping)
		var clamped = (lerped - prev.global_transform.origin).normalized() * offsets[i].length()
		var pos = prev.global_transform.origin + clamped
		next.global_transform.origin = pos
		
		# Rotation
		var wanted = next.global_transform.looking_at(prev.global_transform.origin, prev.global_transform.basis.y).basis		
		next.global_transform.basis = wanted # next.global_transform.basis.slerp(wanted, delta * damping).orthonormalized()
