extends Equipment


export var add_crit = 5.0
func _ready():
	player = get_tree().get_root().find_node("player", true, false)
	player.find_node("collect_area")
	if tier == 0:
		add_crit = 5.0
	elif tier == 1:
		add_crit == 50.0
	elif tier == 2:
		add_crit == 100.0
	

func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		if player.active_equipment.has("crit") and player.active_equipment["crit"] <= tier:
			pass
		else:
			if player.active_equipment.size() >= 2:
				overlap = true
			else:
				if buyable:
					player.crit_chance = add_crit
					player.active_equipment["crit"] = tier
		
		
		
