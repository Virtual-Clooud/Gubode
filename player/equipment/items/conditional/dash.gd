extends Equipment






export var add_dash = 1
func _ready():
	player = get_tree().get_root().find_node("player", true, false)
	player.find_node("collect_area")
	if tier == 0:
		add_dash = 2
	elif tier == 1:
		add_dash = 3
	elif tier == 2:
		add_dash = 4
func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		if player.active_equipment.has("dash") and player.active_equipment["dash"] <= tier:
			pass
		else:
			if player.active_equipment.size() >= 2:
				overlap = true
			else:
				if buyable:
					player.max_dash = add_dash
					player.active_equipment["dash"] = tier
	
