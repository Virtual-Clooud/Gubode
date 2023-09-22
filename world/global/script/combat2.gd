extends Level

func _physics_process(_delta):
	if current_wave == 0 and current_enemies == 0 and portal_spawned == false:
		spawn_portal($Pposition.position)
