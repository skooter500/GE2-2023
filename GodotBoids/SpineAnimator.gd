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
			var offset = bones[i].transform.origin - bones[i-1].transform.origin
			offset = bones[i-1].transform.xform_inv(offset)
			offsets.push_back(offset)

# Called when the node enters the scene tree for the first time.
func _ready():
	calculateOffsets()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in offsets.size():
		var prev = bones[i]
		var next = bones[i + 1]
		
		var wantedPos = prev.transform.xform(offsets[i])
		
		# Clamp it, so they dont get too far apart
		var lerped = lerp(next.transform.origin, wantedPos, delta * damping)
		var clamped = (lerped - prev.transform.origin).limit_length(offsets[i].length())
		var pos = prev.transform.origin + clamped
		next.transform.origin = lerped
		
		
		# Rotation
		var wanted = next.transform.looking_at(prev.transform.origin, Vector3.UP).basis
		# next.transform.basis = wanted 
		# next.transform.basis.slerp(wanted, delta * damping).orthonormalized()
