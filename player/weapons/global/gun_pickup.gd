extends Sprite
onready var harpoon = preload("res://player/weapons/axe/scene/Harpoon.tscn")
var player
var weapon
func _ready():
	player = get_node("../player")
	weapon = harpoon
func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		for x in player.get_children():
			if x.get_name() == "gun":
				x.queue_free()
				player.add_child(weapon.instance())
				weapon = preload("res://player/weapons/revolver/scene/gun.tscn")
			elif x.get_name() == "Harpoon":
				x.queue_free()
				player.add_child(weapon.instance())
				weapon = preload("res://player/weapons/axe/scene/Harpoon.tscn")
