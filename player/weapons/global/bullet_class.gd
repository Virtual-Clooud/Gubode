extends KinematicBody2D
class_name Bullet
# Classe de tiros do jogador

onready var velocity = Vector2()

export var dmg : int = 5
export var life_time : float = 0.7
export var status : Array = [] # Status que bala vai coloca no inimigo
export var speed : int = 800

var born_frame
var bounced = false
var has_target = false
var target

func _ready():
	born_frame = Engine.get_frames_drawn()
	velocity = Vector2(speed,0).rotated(rotation)

func chase(target):
	life_time += 1
	if is_instance_valid(target):
		# Diminui velocidade
		velocity = lerp(velocity, Vector2(speed*0.4, 
			speed*0.4) * position.direction_to(
			target.position), 0.1)
	else:
		velocity = Vector2(speed,0).rotated(rotation)
	rotation = velocity.angle()
func bounce() -> void:
	# Sistema de ricochete
	if is_on_wall() or is_on_floor() or is_on_ceiling():
		life_time -= 0.7
		$Sprite.modulate = Color(1, 0.047059, 0)
		# Fail safe pra garanti que bala aplica status em inimigo sem bounce
		bounced = true
	if is_on_wall():
		if velocity.x > 0:
			position.x -= 15
			velocity = (((Vector2(speed,0).rotated(rotation*rand_range(
				1,1)).bounce(Vector2(1,0)))/10).round()  * Vector2(1.5,1.5)) * 10
		else:
			position.x += 15
			velocity = (((Vector2(speed,0).rotated(rotation*rand_range(
				1,1)).bounce(Vector2(1,0)))/10).round()  * Vector2(1.5,1.5)) * 10
	elif is_on_floor():
		position.y -= 15
		velocity = (((Vector2(speed,0).rotated(rotation*rand_range(
			1,1)).bounce(Vector2(0,1)))/10).round()  * Vector2(1.5,1.5)) * 10
	elif is_on_ceiling():
		position.y += 15
		velocity = (((Vector2(speed,0).rotated(rotation*rand_range(
			1,1)).bounce(Vector2(0,-1)))/10).round()  * Vector2(1.5,1.5)) * 10
	rotation = lerp(rotation, velocity.angle(), 0.5)


func _physics_process(_delta):
	# Check para despawnar
	if Engine.get_frames_drawn() >= born_frame+(
		life_time * Engine.get_frames_per_second()):
		queue_free()

func _on_target_area_area_entered(area):
	if area.is_in_group("enemy"):
		if has_target == false:
			#Verificar se tem inimigo com status "target"
			if area.get_parent().get("status").has("target"):
				target = area.get_parent()
				has_target = true
			else:
				has_target = false
func _on_hit_area_area_entered(area):
	if area.is_in_group("enemy"):
		for x in status.size():
			if area.get_parent().get("status").has(status[x]):
				pass
			else:
				area.get_parent().get("status").append(status[x])
		queue_free()
