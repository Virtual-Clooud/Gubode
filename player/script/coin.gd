extends RigidBody2D
# Script responsável por ser moeda

var player
var chase_player = false

export var valor = 1
export var icone : Texture = preload("res://icon.png")

func _ready():
	$Sprite.set_texture(icone)
	randomize()
	player = get_tree().get_root().find_node("player", true, false)
	player.find_node("collect_area")
	valor = round(rand_range(valor * 5, valor * 1))
func _physics_process(_delta):
	if chase_player:
		linear_velocity = lerp(linear_velocity, Vector2(110,0).rotated(get_angle_to(
			player.position)), 0.5)
		rotation = position.angle_to(player.position)
func _on_detect_area_entered(area):
	if area.is_in_group("player"):
		chase_player = true
func _on_collect_area_entered(area):
	if area.is_in_group("player"):
		player.cash = valor + player.cash
		queue_free()
	
