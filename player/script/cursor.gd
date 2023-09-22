extends Node2D

var previous_mouse_position = Vector2.ZERO
var cursor_speed = Vector2.ZERO
var current_weapon = "nothin"
onready var parent = get_node("..")
func pistolP():
		$bar2.position = lerp($bar2.position, Vector2(450,0), 0.05)
		$bar1.position = lerp($bar1.position, Vector2(-450,0), 0.05)
func pistolS():
	$circle.scale = Vector2(1.5,1.5)
func _ready():
	pass
func _physics_process(delta):
	var current_mouse_position = get_global_mouse_position()
	cursor_speed = (current_mouse_position - previous_mouse_position) / delta
	# Armazena a posição do cursor atual para ser usada no próximo quadro
	previous_mouse_position = current_mouse_position
	global_position = current_mouse_position
	global_rotation_degrees = lerp(
		global_rotation_degrees, cursor_speed.x/10000 * 90, 0.1)
	scale = lerp(scale, 
	Vector2(abs(cursor_speed.x/10000 * 0.4),
	abs(cursor_speed.y/10000 * 0.2))+Vector2(0.07,0.07),0.7)
	# Caso não esteja usando nada só uma bolinha
	if parent.name == "gun":
		$nothin.set_visible(false)
		$gun.set_visible(true)
		$harpoon.set_visible(false)
		if Input.is_action_pressed("primaria") and parent.can_Pshoot:
			$gun.rotation_degrees += 0.5 +(0.5 * (abs((cursor_speed.x + cursor_speed.y))/100))
		if Input.is_action_pressed("secundaria") and parent.can_Sshoot:
			$gun/Circle_hollow.scale = lerp(scale, Vector2(3,3), 0.1)		
		if parent.can_Sshoot== false:
				$gun/Circle_hollow.scale = lerp(scale, Vector2(2.0,2), 0.1)
		else: 
			$gun/Circle_hollow.scale = lerp(scale, Vector2(2.5,2.5), 0.3)
			
		if parent.can_Pshoot:
			$gun/bar2.rotation_degrees = lerp($gun/bar2.rotation_degrees,0, 0.6)
			$gun/bar2.position = lerp($gun/bar2.position, Vector2(300,0), 0.05)
			$gun/bar1.rotation_degrees = lerp($gun/bar2.rotation_degrees,0, 0.6)
			$gun/bar1.position = lerp($gun/bar1.position, Vector2(-300,0), 0.05)
		else:
			$gun/bar2.rotation_degrees = 90
			$gun/bar2.position = Vector2(0,0) 
			$gun/bar1.rotation_degrees = -90
			$gun/bar1.position = Vector2(-0,0)
	
	elif parent.name == "harpoon":
		$nothin.set_visible(false)
		$gun.set_visible(false)
		$harpoon.set_visible(true)



