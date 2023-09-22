extends KinematicBody2D
class_name Equipment

# Script da classe dos equipamentos
export var cost: int = 0
var buyable = true
export var tier: int = 0 # 0 == rústico; 1 == polído; 2 == lendário
var player
var chase_player = false
var overlap = false

export var tipo : String
export var qtd = 1
export var valor = 1
export var icone : Texture = preload("res://icon.png")
func _ready():
		player = get_tree().get_root().find_node("player", true, false)
		var sprite = Sprite.new()
		if player:
				var collectArea = player.get_node("collect_area")
				if collectArea:
						var collisionArea = Area2D.new()
						add_child(collisionArea)

						var collisionShape = CollisionShape2D.new()
						var circleShape = CircleShape2D.new()
						circleShape.radius = 90
						collisionShape.shape = circleShape
						collisionArea.add_child(collisionShape)

						collisionArea.connect("area_entered", self, "_on_Area2D_area_entered")
		sprite.texture = icone
		add_child(sprite)

func _physics_process(delta):
	if player.cash >= cost:
		buyable = true
	else:
		buyable = false
	if overlap == true:
		if Input.is_action_just_pressed("slot1"):
			player.active_equipment.erase(player.active_equipment.keys()[0])
		elif Input.is_action_just_pressed("slot2"):
			player.active_equipment.erase(player.active_equipment.keys()[1])
