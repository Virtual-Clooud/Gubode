extends KinematicBody2D
class_name Player
# Script responsável pela classe do jogador
var masterN
var tilemap
onready var root = get_node("..")


export var life = 3
export var maxlife = 3
var can_lose_life = [true, 0]

export var speed : int = 100
export var maxspeed : int = 350
export var max_dash = 1
export var dash_wait : float = 0.3
export var dash_speed = 30
var dash_qtd = 0
var direction = "none" 
var velocity = Vector2(0,0)

export var flee_timer = 0 # Timer for the player to get out of floor_trap
export var flee_window = 50 # Max frames the player can be standing on floor trap

export var cash = 0
var can_dash = true

export var crit_chance = 0

onready var sprint_dust = preload("res://player/scene/sprint_dust_fx.tscn")
onready var smoke = preload("res://player/scene/smoke_fx.tscn")
onready var dash_puff = preload("res://player/scene/dash_particle_fx.tscn")

var can_smoke = false

var active_equipment = {
	
}

var camera_limit = false

var speed_add = 0
var crit_add = 0
var dash_add = 0

signal player_died
func apply_buffs():
	if active_equipment.size() > 0:
		for x in range(active_equipment.size()):
			if active_equipment.has("speed"):
				pass
			if active_equipment.has("crit"):
				pass
func set_limit():
		var tile
		var up = 0
		var down = 0
		var right = 0
		var left = 0
		if camera_limit == false:
			for tile_idx in range(tilemap.get_used_cells().size()):
				tile = tilemap.get_used_cells()[tile_idx]
				if tilemap.map_to_world(tile).y <= up:
					up = tilemap.map_to_world(tile).y
				if tilemap.map_to_world(tile).y >= down:
					down = tilemap.map_to_world(tile).y
				if tilemap.map_to_world(tile).x >= right:
					right = tilemap.map_to_world(tile).x
				if tilemap.map_to_world(tile).x <= left:
					left = tilemap.map_to_world(tile).x
				$Camera2D.limit_bottom = down + 100
				$Camera2D.limit_top = up - 100
				$Camera2D.limit_left = left - 100
				$Camera2D.limit_right = right + 100
				camera_limit = true
func set_direction():
	if Input.is_action_pressed("left"):
		direction = "left"
	elif Input.is_action_pressed("right"):
		direction = "right"
	elif Input.is_action_pressed("up"):
		direction = "up"
	elif Input.is_action_pressed("down"):
		direction = "down"
	elif Input.is_action_pressed("left") and Input.is_action_pressed("up"):
		direction = "up-left"
	elif Input.is_action_pressed("right") and Input.is_action_pressed("up"):
		direction = "up-right"
	elif Input.is_action_pressed("left") and Input.is_action_pressed("down"):
		direction = "down-left"
	elif Input.is_action_pressed("right") and Input.is_action_pressed("down"):
		direction = "down-right"
func running():
	var rui = smoke.instance()
	rui.position = self.position
	rui.position.y = rui.position.y + 32
	if direction == "up" and velocity.y >= 30:
		rui.rotation_degrees = 90
		root.add_child(rui)
	elif direction == "down" and velocity.y <= -30:
		rui.rotation_degrees = -90
		root.add_child(rui)
	elif direction == "left" and velocity.x >= 30:
		root.add_child(rui)
	elif direction == "right" and velocity.x <= -30:
		rui.rotation_degrees = 180
		root.add_child(rui)
func start_running():
	if velocity.x >= -1 and velocity.x <= 1 and velocity.y >= -1 and velocity.y <= 1:
		can_smoke = true
	if can_smoke:
		var rui = sprint_dust.instance()
		rui.position = self.position
		rui.position.y = rui.position.y + 32
		if Input.is_action_pressed("up") and velocity.y >= -1:
			rui.rotation_degrees = -90
			root.add_child(rui)
			can_smoke = false
		elif Input.is_action_pressed("down") and velocity.y <= 0.1:
			rui.rotation_degrees = 90
			root.add_child(rui)
			can_smoke = false
		if Input.is_action_pressed("left") and velocity.x >= -0.1:
			rui.rotation_degrees = 180
			root.add_child(rui)
			can_smoke = false
		elif Input.is_action_pressed("right") and velocity.x <= 0.1:
			root.add_child(rui)
			can_smoke = false
func dash():
	if Input.is_action_just_pressed("dash") and can_dash and move_and_slide(velocity, Vector2.UP).round() != Vector2(0,0):
		var idash = dash_puff.instance()
		velocity = lerp(velocity, velocity * dash_speed, 0.1)
		idash.rotation = velocity.angle()
		idash.position = self.position
		root.add_child(idash)
# warning-ignore:return_value_discarded
		move_and_slide(velocity)

		$dash_gib_puff/CollisionShape2D.disabled = false
		$dash_gib_puff.rotation = velocity.angle()
		yield(get_tree().create_timer(0.1), "timeout")
		$dash_gib_puff/CollisionShape2D.disabled = true
		dash_qtd += 1
		if dash_qtd == max_dash:
			can_dash = false
			yield(get_tree().create_timer(dash_wait), "timeout")
			# Revert
			can_dash = true
			dash_qtd = 0
		speed = maxspeed
func move():
	set_direction()
	if Input.is_action_pressed("left"):
		start_running()
		velocity.x = lerp(velocity.x, -maxspeed, 0.2)
		$Camera2D.position = lerp($Camera2D.position, Vector2(0,0),0.7)
	elif Input.is_action_pressed("right"):
		start_running()
		velocity.x = lerp(velocity.x, maxspeed, 0.2)
		$Camera2D.position = lerp($Camera2D.position, Vector2(0,0),0.7)
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)
		
	if Input.is_action_pressed("up"):
		start_running()
		velocity.y = lerp(velocity.y, -maxspeed, 0.2)
		$Camera2D.position = lerp($Camera2D.position, Vector2(0,0),0.7)
	elif Input.is_action_pressed("down"):
		start_running()
		velocity.y = lerp(velocity.y, maxspeed, 0.2)
		$Camera2D.position = lerp($Camera2D.position, Vector2(0,0),0.7)
	else:
		velocity.y = lerp(velocity.y, 0, 0.2)
func floor_trap():
	flee_timer += 1
	if flee_timer/flee_window > 1:
		life = life - 1
		flee_timer = 0
func _ready():
# warning-ignore:return_value_discarded
	self.connect("player_died", root, "player_ded")
func _physics_process(_delta):
	apply_buffs()
	tilemap = get_node("../Navigation2D/TileMap")
	if life > maxlife:
		life = maxlife
	move()
	running()
	dash()
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2.UP)
	if can_lose_life[0] == false:
		if Engine.get_frames_drawn() >= can_lose_life[1] + 30:
			can_lose_life[0] = true
	if life == 0:
		emit_signal("player_died")
	if flee_timer != 0:
		flee_timer -= 0.5

