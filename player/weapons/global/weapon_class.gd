extends Node2D
class_name Weapon
# Script da classe de arma

# Control Setup
# Stats
export var bullet_speed : float  = 800
export var alt_bullet_speed : float = 700
export var Pcadency : float = 0.2
export var Scadency : float = 0.2
export var dmg : float = 1
export var alt_dmg : float = 5
export var power_ups = {
	"Pri": 0,
	"Sec": 0
}
# Weapon State
var state = "idle"
var Pshot_frame = Engine.get_frames_drawn()
var Sshot_frame = Engine.get_frames_drawn()
var can_Pshoot = true
var can_Sshoot = true
# Get variables from player
var player
func simple_shot(bullet, brotation, bposition, bspeed, bdmg):
	var ibullet = bullet
	ibullet.rotation_degrees = rad2deg(brotation)
	ibullet.position = bposition
	ibullet.set("speed", bspeed)
	ibullet.set("dmg", bdmg)
	get_tree().get_root().add_child(ibullet)

func simple_mult_shot(
	bullet, brotation, bposition, bspeed, bdmg, xshots, spread):
	#Fazer tiros separados tipo o especial do arco em Hades
	var iangle = spread
	for x in xshots:
		
		var ibullet = bullet.instance()
		ibullet.rotation_degrees = rad2deg(brotation) + iangle
		ibullet.position = bposition
		ibullet.set("speed", bspeed)
		ibullet.set("dmg", bdmg)
		get_tree().get_root().add_child(ibullet)
		iangle = iangle - (spread + spread)/(xshots)
		yield(get_tree().create_timer(0.02), "timeout")
func _ready():
	player = get_tree().get_root().find_node("player", true, false)

func _physics_process(_delta):
	
	if Input.is_action_pressed("primaria"):
		state = "set"
	elif Input.is_action_just_released("primaria"):
		state = "active"
	elif Input.is_action_pressed("secundaria"):
		state = "alt_set"
	elif Input.is_action_just_released("secundaria"):
		state = "alt_active"
			# Update variables from player
	if state == "idle":
		if Engine.get_frames_drawn() >= Pshot_frame+(
			Pcadency * Engine.get_frames_per_second()):
				can_Pshoot = true
		if Engine.get_frames_drawn() >= Sshot_frame+(
			Scadency * Engine.get_frames_per_second()):
				can_Sshoot = true
