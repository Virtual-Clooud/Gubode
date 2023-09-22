extends KinematicBody2D
# travel speed in pixel/s
export var speed = 200

# at which distance to stop moving
# NOTE: setting this value too low might result in jerky movement near destination
const eps = 1.5

# points in the path
var points = []
func chase_tilemap():
	# refresh the points in the path
	points = get_node("../Navigation2D").get_simple_path(get_global_position(), 
	get_global_mouse_position(), false)
	# if the path has more than one point
	if points.size() > 1:
		var distance = points[1] - position
		var direction = distance.normalized() # direction of movement
		if distance.length() > eps or points.size() > 2:
# warning-ignore:return_value_discarded
			move_and_slide(direction*speed)
		else:
# warning-ignore:return_value_discarded
			move_and_slide(Vector2(0, 0)) # close enough - stop moving
		update() # we update the node so it has to draw it self again
func _ready():
	set_physics_process(true)

func _physics_process(_delta):
	chase_tilemap()

func _draw():
	# if there are points to draw
	if points.size() > 1:
		for p in points:
			draw_circle(p - get_global_position(), 8, Color(1, 0, 0)) # we draw a circle (convert to global position first)
