extends Enemy
# Script do perserguidor


var rushing = false
var rush_frame
var start
func _ready():
	player = get_tree().get_root().find_node("player", true, false)

func _physics_process(_delta):
	# Se chegar perto fazer set-up e executar função
	if is_instance_valid(player):
		if position.distance_to(player.position) <= rush_agro and attacking == false:
#			velocity = Vector2(0,0)
#			state = "attack"
#			attacking = true
#			start = Engine.get_frames_drawn()
#			rush()
			pass
	if state == "active":
		if is_instance_valid(player):
			chase()
		else:
			player = get_tree().get_root().find_node("player", true, false)
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2.UP)
	if life <= 0:
		Engine.time_scale -= 0.2
		drop()
		ded()

func _draw():
	# if there are points to draw
	if points.size() > 1:
		for p in points:
			# we draw a circle (convert to global position first)
			draw_circle(p - get_global_position(), 8, Color(1, 0, 0)) 
		
