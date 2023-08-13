extends Navigation

const SPEED = 4.0

var camrot = 0.0

var begin = Vector3()
var end = Vector3()
var m = SpatialMaterial.new()

var path = []
var draw_path = true

func _ready():
	set_process_input(true)
	m.flags_unshaded = true
	m.flags_use_point_size = true
	m.albedo_color = Color.white


func _process(delta):
	if path.size() > 1:
		var to_walk = delta * SPEED
		var to_watch = Vector3.UP
		while to_walk > 0 and path.size() >= 2:
			var pfrom = path[path.size() - 1]
			var pto = path[path.size() - 2]
			to_watch = (pto - pfrom).normalized()
			var d = pfrom.distance_to(pto)
			if d <= to_walk:
				path.remove(path.size() - 1)
				to_walk -= d
			else:
				path[path.size() - 1] = pfrom.linear_interpolate(pto, to_walk / d)
				to_walk = 0
		
		var atpos = path[path.size() - 1]
		var atdir = to_watch
		atdir.y = 0
		
		var t = Transform()
		t.origin = atpos
		t = t.looking_at(atpos + atdir, Vector3.UP)
		get_node("RobotBase").set_transform(t)
		
		if path.size() < 2:
			path = []
			set_process(false)
	else:
		set_process(false)
		

func _input(event):
	if event.is_action("ui_cancel"):
		get_tree().change_scene("res://Menu.tscn")
		
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		var from = get_node("CameraBase/Camera").project_ray_origin(event.position)
		var to = from + get_node("CameraBase/Camera").project_ray_normal(event.position) * 100
		var p = get_closest_point_to_segment(from, to)
		
		begin = get_closest_point(get_node("RobotBase").get_translation())
		end = p
		_update_path()
	
	if event is InputEventMouseMotion:
		if event.button_mask & (BUTTON_MASK_MIDDLE + BUTTON_MASK_RIGHT):
			camrot += event.relative.x * 0.005
			get_node("CameraBase").set_rotation(Vector3(0, camrot, 0))
			print("Camera Rotation: ", camrot)


func _update_path():
	var p = get_simple_path(begin, end, true)
	path = Array(p) # Vector3 array too complex to use, convert to regular array.
	path.invert()
	set_process(true)
	
	if draw_path:
#		var im = get_node("Draw")
#		im.set_material_override(m)
#		im.clear()
#		im.begin(Mesh.PRIMITIVE_POINTS, null)
#		im.add_vertex(begin)
#		im.add_vertex(end)
#		im.end()
#		im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
#		for x in p:
#			im.add_vertex(x)
#		im.end()
		
		get_node("RobotBase/target").clear_points()
#		for i in range(p.size()-1, -1, -1):
		for i in range(p.size()):
			var normal = get_closest_point_normal(p[i]).normalized()
			var offset = normal*0.1
			var _transform = Transform(Basis(normal), p[i]+offset)
			get_node("RobotBase/target").add_point(_transform)
		get_node("RobotBase/target").smooth()
		get_node("RobotBase/target").render(true)


func _on_back_btn_button_down():
	get_tree().change_scene("res://Menu.tscn")
