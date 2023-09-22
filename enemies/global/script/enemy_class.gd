extends KinematicBody2D
class_name Enemy


var player
var root

# Script da classe de inimigo
onready var moeda = preload("res://player/coin.tscn")




var zero = 0
var velocity
var speed = 0
export var maxspeed = 100

onready var status_icon = preload("res://enemies/global/scene/status_icon.tscn")
export var target_time = 3.2
export var target_icon : Texture = preload("res://enemies/global/img/target.png")
export var status : Array

onready var gib = preload("res://enemies/global/scene/gib.tscn")
var imoeda
export var maxlife : int
export var life : int = 1
export var ded_sprite : Texture
export var pain : int = 0
export var max_pain : int = 10 
export var drop_moeda : int
export var gib_sprite : Texture
export var Ngibs : int

####Idle, active, attack, etc##########
var attacking = false
var last_attack
export var state : String
export var rush_agro: int = 200
export var rush_multiplier : float = 4.0

export var impact_fx : PackedScene
export var center_fx : PackedScene

var points
var top
var bottom
const eps = 1.5


	# Define uma função auxiliar para verificar se uma célula está dentro dos limites do tilemap
func drop():
	for x in drop_moeda:
		imoeda = moeda.instance()
		imoeda.position = position
		imoeda.linear_velocity = Vector2(round(rand_range(200,-200)),
		round(rand_range(200,-200)))
		get_tree().get_root().add_child(imoeda)
func directed_death(direction):
	for _x in range(Ngibs + 1):
		var igib = gib.instance()
		igib.position = self.position
		igib.linear_velocity =Vector2(1000,rand_range(30,-30)).rotated(direction)
		get_tree().get_root().add_child(igib)
func splash_death():
	for _x in range(Ngibs + 1):
		var igib = gib.instance()
		igib.position = self.position
		igib.linear_velocity =Vector2(300,rand_range(30,-30)).rotated(rand_range(0,1))
		get_tree().get_root().add_child(igib)
func melee_attack(x_size: float, y_size: float, lifespan: float):
	# Create a new Area2D node
	var area = Area2D.new()
	
	# Add the Area2D node to the "chaser" and "enemies" groups
	area.add_to_group("enemy_attack")
	
	# Create a new CollisionShape2D node
	var shape = CollisionShape2D.new()
	
	# Create a new RectangleShape2D shape
	var rect_shape = RectangleShape2D.new()
	
	# Set the dimensions of the rectangle shape based on the x_size and y_size parameters
	rect_shape.extents = Vector2(x_size / 2.0, y_size / 2.0)
	
	# Set the shape of the CollisionShape2D node to the RectangleShape2D shape
	shape.shape = rect_shape
	
	# Add the CollisionShape2D node as a child of the Area2D node
	area.add_child(shape)
	
	# Create a timer that will remove the Area2D node after lifespan seconds
	var timer = Timer.new()
	timer.wait_time = lifespan
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", area, "queue_free")
	area.add_child(timer)
	
	# Create a new Sprite node
	var sprite = Sprite.new()
	
	# Set the texture of the sprite to ded_sprite
	sprite.texture = ded_sprite
	var sprite_scale = Vector2(x_size / sprite.texture.get_width(), y_size / sprite.texture.get_height())
	
	sprite.scale = sprite_scale
	# Set the position of the sprite relative to the Area2D node
	# Add the Sprite node as a child of the Area2D node
	area.add_child(sprite)
	
	# Set the position of the Area2D node relative to this node
	area.position = position
	
	# Spawn the Area2D node at the current position of this node
	get_parent().add_child(area)
func _ready():
	life = maxlife
	state = "active"
	velocity = Vector2(0,0)
	player = get_node("../player")
	root = get_tree().get_root()
# warning-ignore:return_value_discarded
	self.connect("tree_entered", self.get_parent(), "enemy_spawn")
# warning-ignore:return_value_discarded
	self.connect("tree_exited", self.get_parent(), "enemy_died")
	emit_signal("tree_entered")
	
	add_child_below_node(get_node("."),RayCast2D.new())
	add_child_below_node(get_node("."),RayCast2D.new())
	for x in range(0, get_children().size()):
		if get_child(x).get_class() == "RayCast2D":
			get_child(x).position = $CollisionShape2D.shape.extents
			get_child(x).set_collision_mask(52)
			get_child(x).enabled = true
			get_child(x).set_name("top")
			top = get_child(x)
		if get_child(x).get_class() == "RayCast2D" and get_child(x).get_name() != "top":
			get_child(x).position = Vector2($CollisionShape2D.shape.extents.x, 
			$CollisionShape2D.shape.extents.y * -1)
			get_child(x).set_collision_mask(52)
			get_child(x).enabled = true
			get_child(x).set_name("bottom")
			bottom = get_child(6)
func rush():
		# Para dar chance de ataque
		yield(get_tree().create_timer(0.9), "timeout")
		speed = 0
		# Avançar em linha reta
		speed +=  maxspeed * rush_multiplier
		velocity = Vector2(speed,0).rotated(get_angle_to(
				player.position))
# warning-ignore:return_value_discarded
		move_and_slide(velocity, Vector2.UP)
		
		yield(get_tree().create_timer(0.1), "timeout")
		velocity = Vector2(speed,0)
		attacking = false
		state = "active"
		melee_attack(150,150,0.1)
# warning-ignore:return_value_discarded
		move_and_slide(velocity, Vector2.UP)

func ded():
	if last_attack.is_in_group("shot"):
		directed_death(deg2rad(last_attack.get_parent().rotation_degrees))
	else:
		splash_death()
	queue_free()

func target():
	# Fail safe para target para aplicar apenas 1 vez
	zero += 1
	if zero >= 200:
		status.erase("target")
		zero = 0
	else:
		var icon = status_icon.instance()
		icon.set("time", target_time)
		icon.set_texture(target_icon)
		
		add_child(icon)


func directional_hit(direct):
	pain += 10
	var tween = create_tween()
	tween.tween_property($Sprite, "position", 
		Vector2(pain, 0).rotated(direct), 0.1)
func chase():
	# refresh the points in the path
	points = get_node("../Navigation2D").get_simple_path(get_global_position(), 
	player.get_global_position(), false)
	# if the path has more than one point
	if points.size() > 1:
		var distance = points[1] - position
		var direction = distance.normalized() # direction of movement
		if distance.length() > eps or points.size() > 2:
			velocity = direction*maxspeed

		else:
			velocity = Vector2(0, 0) # close enough - stop moving
		if top.is_colliding():
			velocity = Vector2(0,100)
			yield(get_tree().create_timer(0.05), "timeout")


		update() # we update the node so it has to draw it self again
		# Adicionar 2 raycasts nas pontas da colisão física, estão apontados pra direlçai que está sendo seguida
		# Caso Rayscasts detectem
		# Ver pra onde pra direção está livre
		# Adaptar direção
#Simple Hit animation
func hit():
	pain += 10
	var tween = create_tween()
	tween.tween_property($Sprite, "position", 
		Vector2(pain, -pain), 0.03)
	tween.parallel().tween_property($Sprite, "rotation_degrees", 
		5, 0.03)
	tween.tween_property($Sprite, "position", 
		Vector2(-pain, pain), 0.03)
	tween.tween_property($Sprite, "position", 
		Vector2(0, -pain), 0.03)
	tween.tween_property($Sprite, "position", 
		Vector2(pain, 0), 0.03)
	tween.parallel().tween_property($Sprite, "rotation_degrees", 
		-5, 0.1)
	tween.tween_property($Sprite, "position", 
		Vector2(0, 0), 0.03)
	tween.tween_property($Sprite, "rotation_degrees", 
		0, 0.03)

func _physics_process(_delta):
	pain = lerp(pain, 0, 0.02)
	if is_instance_valid(player):
		pass
	else:
		player = get_node("../player")
	if status.has("target"):
		target()
func _on_Area2D_area_entered(area):
	last_attack = area
	if area.is_in_group("player_dmg"):
		var hitter = area.get_parent()
		Engine.time_scale -= 0.02 * hitter.get("dmg")
		life -= hitter.get("dmg")
		var direct = position.direction_to(area.position).angle()
		hit()
		directional_hit(direct)
		var icenter = load(center_fx.get_path()).instance()
		icenter.position = position
		root.add_child(icenter)
	if area.is_in_group("shot"):
		var iimpact = load(impact_fx.get_path()).instance()
		var bullet_rotation = area.get_parent().rotation_degrees
		iimpact.position = position
		iimpact.rotation_degrees = bullet_rotation + 180
		root.add_child(iimpact)
		
		
