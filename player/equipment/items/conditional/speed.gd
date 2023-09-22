extends Equipment
export var add_speed = 5.0
func _ready():
	player = get_tree().get_root().find_node("player", true, false)
	player.find_node("collect_area")
	if tier == 0:
		add_speed = 1068.0
	elif tier == 1:
		add_speed == 50.0
	elif tier == 2:
		add_speed == 100.0

func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		if player.active_equipment.has("speed") and player.active_equipment["speed"] <= tier:
			pass
		else:
			if player.active_equipment.size() >= 2:
				print("WHICH SHOULD I CHOOSE?")
				overlap = true
			else:
				if buyable:
					player.maxspeed += add_speed
					player.active_equipment["speed"] = tier

		
	
